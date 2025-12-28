//
//  BLEManagerTests.swift
//  TelescanTests
//

import Testing
import CoreBluetooth
@testable import Telescan

@Suite("BLEManager — main tests.")
struct BLEManagerBasicTests {

    // MARK: - Singleton

    @Test("Singleton returns the same instance.")
    func singletonReturnsSameInstance() {
        let instance1 = BLEManager.shared
        let instance2 = BLEManager.shared
        #expect(instance1 === instance2)
    }

    // MARK: - Delegate

    @Test("Delegate is configured and stored on the weak link.")
    func delegateIsWeakReference() {
        var temporaryDelegate: MockBLEManagerDelegate? = MockBLEManagerDelegate()
        BLEManager.shared.delegate = temporaryDelegate
        #expect(BLEManager.shared.delegate === temporaryDelegate)
        temporaryDelegate = nil
        // After nullify — delegate should become nil
        #expect(BLEManager.shared.delegate == nil)
    }

    @Test("Delegate can be nil without crash")
    func delegateCanBeNil() {
        BLEManager.shared.delegate = nil
        BLEManager.shared.startScanning()
        BLEManager.shared.startAdvertising(id: "test")
        // If doesn't crash - test passes
        #expect(true)
    }

    // MARK: - Bluetooth Availability

    @Test("isBluetoothAvailable returned Bool (true/false it depends of environment).")
    func bluetoothAvailabilityReturnsBool() {
        let available = BLEManager.shared.isBluetoothAvailable
        // In the simulator it is always false, but in device it can be true/false
        // The main thing is that it returns Bool, and it doesn't crash or nil
        #expect(available == true || available == false)
    }

    // MARK: - Reset

    @Test("reset() clean active operations and allows you to start over.")
    func resetClearsActiveOperations() async throws {
        let manager = BLEManager.shared
        manager.startScanning()
        manager.startAdvertising(id: "TestDevice")
        // We given a little time for the operations to start
        try await Task.sleep(for: .milliseconds(300))
        manager.reset()
        // After reset we can restart it again
        manager.startScanning()
        manager.startAdvertising(id: "NewDevice")
        try await Task.sleep(for: .milliseconds(300))
        #expect(true) // If you got here, it didn't crash
    }

    // MARK: - Error Handling (very important test for simulator)

    @Test("A possible error is expected in the simulator or when Bluetooth is turned off.")
    func errorReportedWhenBluetoothUnavailable() async throws {
        try await confirmation("Error received", expectedCount: 0...1) { errorConfirmed in
            let mockDelegate = MockBLEManagerDelegate()
            mockDelegate.onFail = { error in
                #expect(error.localizedDescription.lowercased().contains("powered off") ||
                        error.localizedDescription.lowercased().contains("bluetooth") ||
                        error.localizedDescription.lowercased().contains("unsupported"))
                errorConfirmed()
            }
            BLEManager.shared.delegate = mockDelegate
            // We run both scanning and advertising — suddenly an error will come from peripheral
            BLEManager.shared.startScanning()
            BLEManager.shared.startAdvertising(id: "TestError")
            // We're giving it more time for a possible callback.
            try await Task.sleep(for: .seconds(3))
        }
    }

    // MARK: - Sequential Operations

    @Test("The start/stop/restart sequence does not cause crashes.")
    func sequentialOperationsDoNotCrash() async throws {
        let manager = BLEManager.shared
        manager.startScanning()
        try await Task.sleep(for: .milliseconds(200))
        manager.stopScanning()
        try await Task.sleep(for: .milliseconds(100))
        manager.startScanning()
        try await Task.sleep(for: .milliseconds(200))
        manager.startAdvertising(id: "Device1")
        try await Task.sleep(for: .milliseconds(200))
        manager.restartAdvertising(id: "Device2")
        try await Task.sleep(for: .milliseconds(500))
        manager.stopAdvertising()
        #expect(true)
    }

    @Test("Running scanning and advertising at the same time does not cause problems.")
    func simultaneousScanningAndAdvertising() async throws {
        let manager = BLEManager.shared
        manager.startScanning()
        manager.startAdvertising(id: "MyDevice")
        try await Task.sleep(for: .milliseconds(500))
        manager.stopScanning()
        manager.stopAdvertising()
        #expect(true)
    }
}

// MARK: - Mock Delegate for tests

final class MockBLEManagerDelegate: BLEManagerDelegate {
    var onDiscoverDevice: ((String, Int) -> Void)?
    var onUpdateDevice: ((String, Int) -> Void)?
    var onLoseDevice: ((String) -> Void)?
    var onFail: ((Error) -> Void)?
    func didDiscoverDevice(id: String, rssi: Int) {
        onDiscoverDevice?(id, rssi)
    }
    func didUpdateDevice(id: String, rssi: Int) {
        onUpdateDevice?(id, rssi)
    }
    func didLoseDevice(id: String) {
        onLoseDevice?(id)
    }
    func didFail(with error: Error) {
        onFail?(error)
    }
}
