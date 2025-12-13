////
//// BLEManager.swift
//// Mesh-like BLE manager with background support
////
//
//import Foundation
//import CoreBluetooth
//import AVFoundation
//import UIKit
//
//
//public final class BLEManager: NSObject, BLEManagerProtocol, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate {
//
//    public static let shared = BLEManager()
//    public weak var delegate: BLEManagerDelegate?
//
//    // MARK: - Public State
//    public var isBluetoothAvailable: Bool {
//        central.state == .poweredOn
//    }
//
//    // MARK: - Private
//    private var central: CBCentralManager!
//    private var peripheral: CBPeripheralManager!
//    private let queue = DispatchQueue(label: "com.raketa.ble.queue")
//    private let serviceUUID = CBUUID(string: "FFF0")
//
//    private var isScanningActive = false
//    private var shouldRestoreScanning = false
//    private var isAdvertisingActive = false
//    private var pendingAdvertisingID: String?
//
//    private var devicesLastSeen: [String: Date] = [:]
//    private let deviceTimeout: TimeInterval = 6.0
//    private var cleanupTimer: Timer?
//
//    private var connectionCandidates: [CBPeripheral] = []
//    private var peripherals: [String: PeripheralState] = [:]
//    private var lastGlobalConnectAttempt: Date = .distantPast
//
//    // MARK: - Init
//    private override init() {
//        super.init()
//        print("BLEManager init")
//        central = CBCentralManager(delegate: self,
//                                   queue: queue,
//                                   options: [
//                                    CBCentralManagerOptionRestoreIdentifierKey: "com.raketa.ble.central",
//                                    CBCentralManagerOptionShowPowerAlertKey: true
//                                   ])
//
//        peripheral = CBPeripheralManager(delegate: self,
//                                         queue: queue,
//                                         options: [
//                                            CBPeripheralManagerOptionRestoreIdentifierKey: "com.raketa.ble.peripheral",
//                                            CBPeripheralManagerOptionShowPowerAlertKey: true
//                                         ])
//        startCleanupTimer()
//    }
//
//    deinit {
//        print("BLEManager deinit")
//        cleanupTimer?.invalidate()
//        stopAdvertising()
//        stopScanning()
//    }
//
//    // MARK: - Public API
//    public func startScanning() {
//        print("startScanning called")
//        queue.async { [weak self] in
//            guard let self = self else { return }
//            if self.central.state != .poweredOn {
//                print("Central not powered on, will restore scanning later")
//                self.shouldRestoreScanning = true
//                return
//            }
//            if self.isScanningActive { return }
//            let allowDuplicates = true
//            self.central.scanForPeripherals(withServices: [self.serviceUUID],
//                                            options: [CBCentralManagerScanOptionAllowDuplicatesKey: allowDuplicates])
//            self.isScanningActive = true
//            self.shouldRestoreScanning = false
//            print("Scanning started")
//        }
//    }
//
//    public func stopScanning() {
//        print("stopScanning called")
//        queue.async { [weak self] in
//            guard let self = self else { return }
//            if self.isScanningActive {
//                self.central.stopScan()
//                self.isScanningActive = false
//                print("Scanning stopped")
//            }
//        }
//    }
//
//    public func startAdvertising(id: String) {
//        print("startAdvertising called with id: \(id)")
//        queue.async { [weak self] in
//            guard let self = self else { return }
//            self.pendingAdvertisingID = id
//            self.startAdvertisingIfReady()
//        }
//    }
//
//    private func startAdvertisingIfReady() {
//        guard let peripheral = peripheral,
//              peripheral.state == .poweredOn,
//              let id = pendingAdvertisingID else { return }
//        let adv: [String: Any] = [
//            CBAdvertisementDataLocalNameKey: String(id.prefix(18)),
//            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]
//        ]
//        peripheral.stopAdvertising()
//        peripheral.startAdvertising(adv)
//        isAdvertisingActive = true
//        print("Advertising started for id: \(id)")
//    }
//
//    public func stopAdvertising() {
//        print("stopAdvertising called")
//        queue.async { [weak self] in
//            guard let self = self else { return }
//            self.peripheral.stopAdvertising()
//            self.isAdvertisingActive = false
//            self.pendingAdvertisingID = nil
//            print("Advertising stopped")
//        }
//    }
//
//    public func reset() {
//        print("reset called")
//        stopScanning()
//        stopAdvertising()
//        devicesLastSeen.removeAll()
//        shouldRestoreScanning = false
//        connectionCandidates.removeAll()
//        peripherals.removeAll()
//        print("BLEManager reset completed")
//    }
//
//    public func forceRestartScanningIfNeeded() {
//        print("forceRestartScanningIfNeeded called")
//        startScanning()
//        startAdvertisingIfReady()
//    }
//
//    // MARK: - Device Cleanup
//    private func startCleanupTimer() {
//        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            self?.checkForLostDevices()
//        }
//    }
//
//    private func checkForLostDevices() {
//        let now = Date()
//        for (id, last) in devicesLastSeen {
//            if now.timeIntervalSince(last) > deviceTimeout {
//                devicesLastSeen.removeValue(forKey: id)
//                DispatchQueue.main.async { [weak self] in
//                    self?.delegate?.didLoseDevice(id: id)
//                    print("Device lost: \(id)")
//                }
//            }
//        }
//    }
//
//    // MARK: - Connection Queue
//    private func tryConnectFromQueue() {
//        queue.async { [weak self] in
//            guard let self = self else { return }
//            while !self.connectionCandidates.isEmpty {
//                let peripheral = self.connectionCandidates.removeFirst()
//                let id = peripheral.identifier.uuidString
//                if self.peripherals[id]?.isConnected == true || self.peripherals[id]?.isConnecting == true {
//                    continue
//                }
//                self.peripherals[id] = PeripheralState(
//                    peripheral: peripheral,
//                    characteristic: nil,
//                    peerID: nil,
//                    isConnecting: true,
//                    isConnected: false,
//                    lastConnectionAttempt: Date()
//                )
//                peripheral.delegate = self
//                let options: [String: Any] = [
//                    CBConnectPeripheralOptionNotifyOnConnectionKey: true,
//                    CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
//                    CBConnectPeripheralOptionNotifyOnNotificationKey: true
//                ]
//                self.central.connect(peripheral, options: options)
//                self.lastGlobalConnectAttempt = Date()
//                print("Attempting connection to peripheral: \(id)")
//                break
//            }
//        }
//    }
//
//    // MARK: - CBCentralManagerDelegate
//    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        print("centralManagerDidUpdateState: \(central.state.rawValue)")
//        if central.state == .poweredOn {
//            if shouldRestoreScanning || isScanningActive {
//                startScanning()
//            }
//        } else {
//            isScanningActive = false
//        }
//    }
//
//    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
//            for p in peripherals {
//                devicesLastSeen[p.identifier.uuidString] = Date()
//            }
//        }
//        startScanning()
//    }
//
//    public func centralManager(_ central: CBCentralManager,
//                               didDiscover peripheral: CBPeripheral,
//                               advertisementData: [String: Any],
//                               rssi RSSI: NSNumber) {
//        let peripheralID: String
//        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data],
//           let payload = serviceData[serviceUUID],
//           let idString = String(data: payload, encoding: .utf8) {
//            peripheralID = idString
//        } else if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
//            peripheralID = name
//        } else {
//            return
//        }
//
//        devicesLastSeen[peripheralID] = Date()
//        DispatchQueue.main.async {
//            self.delegate?.didDiscoverDevice(id: peripheralID, rssi: RSSI.intValue)
//            self.delegate?.didUpdateDevice(id: peripheralID, rssi: RSSI.intValue)
//            print("Discovered/Updated device: id=\(peripheralID) rssi=\(RSSI.intValue)")
//        }
//
//        connectionCandidates.append(peripheral)
//        tryConnectFromQueue()
//    }
//
//    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        let id = peripheral.identifier.uuidString
//        if var state = peripherals[id] {
//            state.isConnecting = false
//            state.isConnected = true
//            peripherals[id] = state
//        }
//        peripheral.discoverServices([serviceUUID])
//        print("Connected to peripheral: \(id)")
//    }
//
//    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        peripherals.removeValue(forKey: peripheral.identifier.uuidString)
//        tryConnectFromQueue()
//        if let error = error {
//            print("Failed to connect to peripheral: \(peripheral.identifier.uuidString) error: \(error)")
//        }
//    }
//
//    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        peripherals.removeValue(forKey: peripheral.identifier.uuidString)
//        tryConnectFromQueue()
//        print("Disconnected from peripheral: \(peripheral.identifier.uuidString)")
//    }
//
//    // MARK: - CBPeripheralManagerDelegate
//    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        print("peripheralManagerDidUpdateState: \(peripheral.state.rawValue)")
//        if peripheral.state == .poweredOn {
//            startAdvertisingIfReady()
//        } else {
//            isAdvertisingActive = false
//        }
//    }
//
//    public func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
//        if let adv = dict[CBPeripheralManagerRestoredStateAdvertisementDataKey] as? [String: Any],
//           let sd = adv[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data],
//           let payload = sd[serviceUUID],
//           let idString = String(data: payload, encoding: .utf8) {
//            pendingAdvertisingID = idString
//            isAdvertisingActive = true
//        }
//    }
//
//    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
//        if let error = error {
//            DispatchQueue.main.async { self.delegate?.didFail(with: error) }
//            isAdvertisingActive = false
//            print("Advertising failed: \(error)")
//        } else {
//            isAdvertisingActive = true
//            print("Advertising started successfully")
//        }
//    }
//
//    // MARK: - CBPeripheralDelegate
//    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard error == nil, let services = peripheral.services else { return }
//        for service in services {
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//        print("Discovered services for peripheral: \(peripheral.identifier.uuidString)")
//    }
//
//    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {}
//    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {}
//}
//
//// MARK: - PeripheralState
//private struct PeripheralState {
//    let peripheral: CBPeripheral
//    var characteristic: CBCharacteristic?
//    var peerID: String?
//    var isConnecting: Bool
//    var isConnected: Bool
//    var lastConnectionAttempt: Date?
//}

import Foundation
import CoreBluetooth

public final class BLEManager: NSObject, BLEManagerProtocol {
    
    public static let shared = BLEManager()
    public weak var delegate: BLEManagerDelegate?
    
    public var isBluetoothAvailable: Bool {
        central?.state == .poweredOn && peripheral?.state == .poweredOn
    }
    
    private var central: CBCentralManager?
    private var peripheral: CBPeripheralManager?
    
    private var isAdvertisingActive = false
    private var isScanningActive = false
    private var shouldRestoreScanning = false
    private var pendingAdvertisingID: String?
    
    private let queue = DispatchQueue(label: "blemanager.queue")
    
    private var devicesLastSeen: [String: Date] = [:]
    private let deviceTimeout: TimeInterval = 5.0
    private var cleanupTimer: Timer?
    
    private let serviceUUID = CBUUID(string: "FFF0")
    
    private override init() {
        super.init()
        print("BLEManager init")
        
        central = CBCentralManager(
            delegate: self,
            queue: queue,
            options: [
                CBCentralManagerOptionShowPowerAlertKey: true,
                CBCentralManagerOptionRestoreIdentifierKey: "BLECentralRestoreID"
            ]
        )
        
        peripheral = CBPeripheralManager(
            delegate: self,
            queue: queue,
            options: [
                CBPeripheralManagerOptionRestoreIdentifierKey: "BLEPeripheralRestoreID"
            ]
        )
        
        startCleanupTimer()
    }
    
    // MARK: - Scanning
    public func startScanning() {
        print("startScanning called")
        queue.async { [weak self] in
            guard let self else { return }
            
            if central?.state != .poweredOn {
                shouldRestoreScanning = true
                return
            }
            
            if isScanningActive { return }
            
            let opts = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            central?.scanForPeripherals(withServices: [serviceUUID], options: opts)
            isScanningActive = true
            shouldRestoreScanning = false
            print("Scanning started")
        }
    }
    
    public func stopScanning() {
        print("stopScanning called")
        queue.async { [weak self] in
            guard let self = self, let central = self.central else { return }
            if !self.isScanningActive { return }
            central.stopScan()
            self.isScanningActive = false
            print("Scanning stopped")
        }
    }
    
    // MARK: - Advertising
    public func startAdvertising(id: String) {
        print("startAdvertising called with id: \(id)")
        queue.async { [weak self] in
            guard let self = self, let peripheral = self.peripheral else { return }
            self.pendingAdvertisingID = id
            
            if peripheral.state == .poweredOn {
                let adv: [String: Any] = [
                    CBAdvertisementDataLocalNameKey: id,
                    CBAdvertisementDataServiceUUIDsKey: [self.serviceUUID]
                ]
                peripheral.stopAdvertising()
                peripheral.startAdvertising(adv)
                print("Advertising started for id: \(id)")
            }
        }
    }
    
    public func stopAdvertising() {
        print("stopAdvertising called")
        queue.async { [weak self] in
            guard let self = self else { return }
            self.peripheral?.stopAdvertising()
            self.isAdvertisingActive = false
            print("Advertising stopped")
        }
    }
    
    // MARK: - Reset
    public func reset() {
        print("reset called")
        queue.async { [weak self] in
            guard let self = self else { return }
            self.peripheral?.stopAdvertising()
            self.central?.stopScan()
            self.isAdvertisingActive = false
            self.isScanningActive = false
            self.pendingAdvertisingID = nil
            self.devicesLastSeen.removeAll()
            print("BLEManager reset complete")
        }
    }
    
    // MARK: - Device cleanup
    private func startCleanupTimer() {
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkForLostDevices()
        }
    }
    
    private func checkForLostDevices() {
        let now = Date()
        for (id, lastSeen) in devicesLastSeen {
            if now.timeIntervalSince(lastSeen) > deviceTimeout {
                devicesLastSeen.removeValue(forKey: id)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didLoseDevice(id: id)
                    print("Device lost: \(id)")
                }
            }
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension BLEManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState: \(central.state.rawValue)")
        if central.state == .poweredOn {
            if shouldRestoreScanning {
                startScanning()
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String: Any],
                               rssi RSSI: NSNumber) {
        guard let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String else { return }
        devicesLastSeen[name] = Date()
        DispatchQueue.main.async {
            self.delegate?.didDiscoverDevice(id: name, rssi: RSSI.intValue)
            self.delegate?.didUpdateDevice(id: name, rssi: RSSI.intValue)
            print("Discovered/Updated device: id=\(name) rssi=\(RSSI.intValue)")
        }
    }
    
    public func centralManager(_ central: CBCentralManager,
                               willRestoreState dict: [String: Any]) {
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            for p in peripherals { devicesLastSeen[p.name ?? ""] = Date() }
        }
    }
}

// MARK: - CBPeripheralManagerDelegate
extension BLEManager: CBPeripheralManagerDelegate {
    
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState: \(peripheral.state.rawValue)")
        if peripheral.state == .poweredOn, let id = pendingAdvertisingID {
            startAdvertising(id: id)
        }
    }
    
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            delegate?.didFail(with: error)
            print("Advertising failed: \(error)")
        } else {
            isAdvertisingActive = true
            print("Advertising started successfully")
        }
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  willRestoreState dict: [String: Any]) {
        if let adv = dict[CBPeripheralManagerRestoredStateAdvertisementDataKey] as? [String: Any],
           let name = adv[CBAdvertisementDataLocalNameKey] as? String {
            startAdvertising(id: name)
        }
    }
}
