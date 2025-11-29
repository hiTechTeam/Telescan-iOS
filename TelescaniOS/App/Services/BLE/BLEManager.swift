import Foundation
import CoreBluetooth


public final class BLEManager: NSObject, BLEManagerProtocol {
    
    public static let shared = BLEManager()
    public weak var delegate: BLEManagerDelegate?
    
    public var isBluetoothAvailable: Bool {
        central?.state == .poweredOn && peripheral?.state == .poweredOn
    }
    
    // MARK: - CoreBluetooth
    private var central: CBCentralManager?
    private var peripheral: CBPeripheralManager?
    
    // MARK: - State
    private var isAdvertisingActive = false
    private var isScanningActive = false
    private var pendingAdvertisingID: String?
    
    private let queue = DispatchQueue(label: "blemanager.queue")
    
    // MARK: - Devices tracking
    private var devicesLastSeen: [String: Date] = [:]
    private let deviceTimeout: TimeInterval = 5.0
    private var cleanupTimer: Timer?
    
    private override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: queue)
        peripheral = CBPeripheralManager(delegate: self, queue: queue)
        startCleanupTimer()
    }
    
    // MARK: - BLEManagerProtocol
    public func startScanning() {
        queue.async { [weak self] in
            guard let self = self, let central = self.central else { return }
            guard self.isAdvertisingActive else { return }
            guard central.state == .poweredOn else { return }
            if self.isScanningActive { return }
            
            central.scanForPeripherals(withServices: nil,
                                       options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            self.isScanningActive = true
        }
    }
    
    public func stopScanning() {
        queue.async { [weak self] in
            guard let self = self, let central = self.central else { return }
            if !self.isScanningActive { return }
            central.stopScan()
            self.isScanningActive = false
        }
    }
    
    public func startAdvertising(id: String) {
        queue.async { [weak self] in
            guard let self = self, let peripheral = self.peripheral else { return }
            
            if peripheral.state != .poweredOn {
                self.pendingAdvertisingID = id
                return
            }
            
            self.pendingAdvertisingID = nil
            let adv: [String: Any] = [
                CBAdvertisementDataLocalNameKey: id
            ]
            peripheral.stopAdvertising()
            peripheral.startAdvertising(adv)
        }
    }
    
    public func stopAdvertising() {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.peripheral?.stopAdvertising()
            self.isAdvertisingActive = false
            self.stopScanning()
            self.devicesLastSeen.removeAll()
        }
    }
    
    public func reset() {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.peripheral?.stopAdvertising()
            self.central?.stopScan()
            self.isAdvertisingActive = false
            self.isScanningActive = false
            self.pendingAdvertisingID = nil
            self.devicesLastSeen.removeAll()
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
                }
            }
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension BLEManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        queue.async { [weak self] in
            guard let self = self else { return }
            if central.state != .poweredOn {
                self.stopScanning()
            } else if central.state == .poweredOn && self.isAdvertisingActive {
                self.startScanning()
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String : Any],
                               rssi RSSI: NSNumber) {
        guard let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String else { return }
        
        // Обновляем время последнего сигнала
        devicesLastSeen[name] = Date()
        
        DispatchQueue.main.async {
            self.delegate?.didDiscoverDevice(id: name, rssi: RSSI.intValue)
            self.delegate?.didUpdateDevice(id: name, rssi: RSSI.intValue)
        }
    }
}

// MARK: - CBPeripheralManagerDelegate
extension BLEManager: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        queue.async { [weak self] in
            guard let self = self else { return }
            if peripheral.state == .poweredOn {
                if let id = self.pendingAdvertisingID {
                    self.pendingAdvertisingID = nil
                    self.startAdvertising(id: id)
                }
            } else {
                self.stopAdvertising()
            }
        }
    }
    
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFail(with: error)
            }
        } else {
            queue.async { [weak self] in
                self?.isAdvertisingActive = true
            }
        }
    }
}
