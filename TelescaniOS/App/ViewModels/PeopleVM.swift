import Foundation
import SwiftUI
import CoreBluetooth

final class PeopleViewModel: ObservableObject, BLEManagerDelegate {
    @Published var devices: [String: Int] = [:]
    @Published var distances: [String: Int] = [:]
    @Published var userCache: [String: NearbyUser] = [:]
    @Published var isScanningEnabled: Bool = false
    
    private var distanceTimer: Timer?
    private let validIDPattern = #"^\d+$"#
    
    init() {
        BLEManager.shared.delegate = self
        startDistanceUpdater()
    }
    
    deinit {
        distanceTimer?.invalidate()
    }
    
    func loadUserIfNeeded(tgID: String) async {
        guard userCache[tgID] == nil else { return }
        
        if let intID = Int(tgID) {
            do {
                let data = try await FetchService.fetch.fetchUserDataByTGID(for: intID)
                let user = NearbyUser(
                    id: tgID,
                    tgName: data.tg_name,
                    tgUsername: data.tg_username,
                    photoURL: data.photoS3URL
                )
                userCache[tgID] = user
            } catch {
                print("Failed to load user: \(error)")
            }
        }
    }
    
    // MARK: - Toggle управление сканированием
    func toggleScanning(_ enabled: Bool) {
        isScanningEnabled = enabled
        if enabled {
            BLEManager.shared.startScanning()
        } else {
            BLEManager.shared.stopScanning()
            clearDevices()
        }
    }
    
    // MARK: - Расстояния
    private func startDistanceUpdater() {
        distanceTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.recalculateDistances()
        }
    }
    
    private func recalculateDistances() {
        for (id, rssi) in devices {
            distances[id] = distanceFromRSSI(rssi)
        }
    }
    
    func distanceFromRSSI(_ rssi: Int, txPower: Int = -59, n: Double = 2) -> Int {
        let ratio = Double(txPower - rssi) / (10 * n)
        let distance = pow(10.0, ratio)
        return max(1, Int(distance.rounded()))
    }
    
    // MARK: - BLEManagerDelegate
    func didDiscoverDevice(id: String, rssi: Int) {
        guard id.range(of: validIDPattern, options: .regularExpression) != nil else { return }
        DispatchQueue.main.async { self.devices[id] = rssi }
    }
    
    func didUpdateDevice(id: String, rssi: Int) {
        guard id.range(of: validIDPattern, options: .regularExpression) != nil else { return }
        DispatchQueue.main.async { self.devices[id] = rssi }
    }
    
    func didLoseDevice(id: String) {
        DispatchQueue.main.async { self.devices.removeValue(forKey: id) }
    }
    
    func didFail(with error: Error) {
        print("BLE error: \(error)")
    }
    
    func clearDevices() {
        DispatchQueue.main.async {
            self.devices.removeAll()
            self.distances.removeAll()
        }
    }
}
