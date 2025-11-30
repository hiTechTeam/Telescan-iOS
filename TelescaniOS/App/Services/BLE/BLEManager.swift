import Foundation
import CoreBluetooth
import AVFoundation

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
    private var pendingAdvertisingID: String?

    private let queue = DispatchQueue(label: "blemanager.queue")

    private var devicesLastSeen: [String: Date] = [:]
    private let deviceTimeout: TimeInterval = 5.0
    private var cleanupTimer: Timer?

    private let serviceUUID = CBUUID(string: "FFF0")

    // Silent audio session keeps app alive in background
    private var audioSession: AVAudioSession?

    private override init() {
        super.init()

        setupAudioSession()

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

    private func setupAudioSession() {
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession?.setCategory(.playback, options: [.mixWithOthers])
            try audioSession?.setActive(true)
        } catch {
            print("Failed to activate audio session: \(error)")
        }
    }

    // MARK: - Scanning
    public func startScanning() {
        queue.async { [weak self] in
            guard let self = self, let central = self.central else { return }
            guard central.state == .poweredOn else { return }
            if self.isScanningActive { return }

            let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            central.scanForPeripherals(withServices: [self.serviceUUID], options: options)
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

    // MARK: - Advertising
    public func startAdvertising(id: String) {
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
            }
        }
    }

    public func stopAdvertising() {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.peripheral?.stopAdvertising()
            self.isAdvertisingActive = false
            // не останавливаем сканирование
        }
    }

    // MARK: - Reset
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
        if central.state == .poweredOn && isScanningActive {
            startScanning()
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
        if peripheral.state == .poweredOn, let id = pendingAdvertisingID {
            startAdvertising(id: id)
        }
    }

    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error { delegate?.didFail(with: error) }
        else { isAdvertisingActive = true }
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  willRestoreState dict: [String: Any]) {
        if let adv = dict[CBPeripheralManagerRestoredStateAdvertisementDataKey] as? [String: Any],
           let name = adv[CBAdvertisementDataLocalNameKey] as? String {
            startAdvertising(id: name)
        }
    }
}
