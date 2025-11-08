import SwiftUI
import CoreBluetooth
import Combine

protocol BluetoothManagerDelegate: AnyObject {
    func didDiscoverPeer(_ peer: UserPeer)
}

class BluetoothManager: NSObject, ObservableObject {
    @Published var state: CBManagerState = .unknown
    var isScanningEnabled: Bool = false
    
    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!
    
    weak var delegate: BluetoothManagerDelegate?
    
    let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-1234567890AB")
    let characteristicUUID = CBUUID(string: "87654321-4321-4321-4321-BA0987654321")
    
    private var localPeer: UserPeer?
    private var profileCharacteristic: CBMutableCharacteristic!
    
    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Запуск/остановка
    func start(peer: UserPeer) {
        localPeer = peer
        isScanningEnabled = true
        setupPeripheralService()
        updateScanningAndAdvertising()
    }
    
    func stop() {
        isScanningEnabled = false
        stopAdvertising()
        stopScanning()
    }
    
    private func updateScanningAndAdvertising() {
        guard isScanningEnabled else { return }
        if centralManager.state == .poweredOn { startScanning() }
        if peripheralManager.state == .poweredOn { startAdvertising() }
    }
    
    // MARK: - Реклама
    private func setupPeripheralService() {
        guard let peer = localPeer else { return }
        let peerInfo = PeerInfo(id: peer.id, name: peer.name, socialName: peer.socialName, socialLink: peer.socialLink)
        let data = (try? JSONEncoder().encode(peerInfo)) ?? Data()
        profileCharacteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: [.read],
            value: data,
            permissions: [.readable]
        )
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [profileCharacteristic]
        peripheralManager.add(service)
    }
    
    private func startAdvertising() {
        guard let peer = localPeer else { return }
        let shortID = String(peer.id.prefix(8))
        peripheralManager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: shortID
        ])
    }
    
    private func startScanning() {
        centralManager.scanForPeripherals(
            withServices: [serviceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        )
    }
    
    private func stopAdvertising() { peripheralManager.stopAdvertising() }
    private func stopScanning() { centralManager.stopScan() }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        state = central.state
        updateScanningAndAdvertising()
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        guard let _ = advertisementData[CBAdvertisementDataLocalNameKey] as? String else { return }
        peripheral.delegate = self
        if discoveredPeripherals[peripheral.identifier] == nil {
            discoveredPeripherals[peripheral.identifier] = peripheral
            centralManager.connect(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }
}

// MARK: - CBPeripheralDelegate
extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for char in characteristics {
            if char.uuid == characteristicUUID {
                peripheral.readValue(for: char)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        guard let data = characteristic.value,
              let peerInfo = try? JSONDecoder().decode(PeerInfo.self, from: data) else { return }
        
        let peer = UserPeer(
            id: peerInfo.id,
            name: peerInfo.name,
            socialName: peerInfo.socialName,
            socialLink: peerInfo.socialLink
        )
        
        DispatchQueue.main.async {
            self.delegate?.didDiscoverPeer(peer)
        }
    }
}

// MARK: - CBPeripheralManagerDelegate
extension BluetoothManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        updateScanningAndAdvertising()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager,
                           didReceiveRead request: CBATTRequest) {
        guard let value = profileCharacteristic.value else { return }
        if request.offset > value.count { return }
        request.value = value.subdata(in: request.offset..<value.count)
        peripheral.respond(to: request, withResult: .success)
    }
}
