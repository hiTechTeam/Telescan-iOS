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
    
    private var restartWorkItem: DispatchWorkItem?
    
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
    public func restartAdvertising(id: String) {
        queue.async { [weak self] in
            guard let self, let peripheral = self.peripheral else { return }
            
            // Отменяем предыдущий restart, если он ещё не выполнен
            self.restartWorkItem?.cancel()
            
            self.pendingAdvertisingID = id
            
            let workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                let adv: [String: Any] = [
                    CBAdvertisementDataLocalNameKey: id,
                    CBAdvertisementDataServiceUUIDsKey: [self.serviceUUID]
                ]
                peripheral.stopAdvertising()
                peripheral.startAdvertising(adv)
                self.isAdvertisingActive = true
                print("Advertising restarted with id: \(id)")
            }
            
            self.restartWorkItem = workItem
            
            // Задержка перед перезапуском, чтобы избежать конфликтов с startAdvertising
            self.queue.asyncAfter(deadline: .now() + 0.3, execute: workItem)
        }
    }
    
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
