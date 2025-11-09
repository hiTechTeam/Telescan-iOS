import Foundation
import CoreBluetooth
import UIKit

protocol BluetoothManagerDelegate: AnyObject {
    func didDiscoverPeer(_ peer: UserPeer)
}

final class BluetoothManager: NSObject, ObservableObject {
    @Published var state: CBManagerState = .unknown
    @Published var isScanning = false

    private var central: CBCentralManager!
    private var peripheral: CBPeripheralManager!

    weak var delegate: BluetoothManagerDelegate?

    private let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-1234567890AB")
    private let infoUUID = CBUUID(string: "11111111-1111-1111-1111-111111111111")
    private let imageUUID = CBUUID(string: "22222222-2222-2222-2222-222222222222")

    private var profile: UserPeer?
    private var infoCharacteristic: CBMutableCharacteristic!
    private var imageCharacteristic: CBMutableCharacteristic!

    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]
    private var imageDataCache: [UUID: Data] = [:]

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main)
        peripheral = CBPeripheralManager(delegate: self, queue: .main)
    }

    func start(peer: UserPeer) {
        profile = peer
        isScanning = true
        configurePeripheral()
        updateState()
    }

    func stop() {
        isScanning = false
        peripheral.stopAdvertising()
        central.stopScan()
    }
}

// MARK: - Peripheral (Advertising)

private extension BluetoothManager {
    func configurePeripheral() {
        guard let peer = profile else { return }

        let peerInfo = PeerInfo(
            id: peer.id,
            socialName: peer.socialName,
            socialLink: peer.socialLink,
            profileImageData: nil 
        )

        let infoData = try? JSONEncoder().encode(peerInfo)

        infoCharacteristic = CBMutableCharacteristic(
            type: infoUUID,
            properties: [.read],
            value: infoData,
            permissions: [.readable]
        )

        imageCharacteristic = CBMutableCharacteristic(
            type: imageUUID,
            properties: [.read],
            value: nil,
            permissions: [.readable]
        )

        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [infoCharacteristic, imageCharacteristic]

        peripheral.removeAllServices()
        peripheral.add(service)
    }

    func startAdvertising() {
        guard let peer = profile else { return }
        peripheral.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: peer.socialName
        ])
    }
}

// MARK: - Central (Scanning)

private extension BluetoothManager {
    func startScanning() {
        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    func connect(_ peripheral: CBPeripheral) {
        discoveredPeripherals[peripheral.identifier] = peripheral
        peripheral.delegate = self
        central.connect(peripheral)
    }

    func readImage(for peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.readValue(for: characteristic)
    }
}

// MARK: - Delegate Implementations

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        state = central.state
        updateState()
    }

    private func updateState() {
        guard isScanning else { return }
        if central.state == .poweredOn { startScanning() }
        if peripheral.state == .poweredOn { startAdvertising() }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard discoveredPeripherals[peripheral.identifier] == nil else { return }
        connect(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for s in services where s.uuid == serviceUUID {
            peripheral.discoverCharacteristics([infoUUID, imageUUID], for: s)
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let chars = service.characteristics else { return }
        for c in chars {
            if c.uuid == infoUUID {
                peripheral.readValue(for: c)
            } else if c.uuid == imageUUID {
                peripheral.readValue(for: c)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        guard error == nil else { return }

        if characteristic.uuid == infoUUID,
           let data = characteristic.value,
           let info = try? JSONDecoder().decode(PeerInfo.self, from: data) {
            let image = imageDataCache[peripheral.identifier].flatMap { UIImage(data: $0) }
            let peer = UserPeer(
                id: info.id,
                socialName: info.socialName,
                socialLink: info.socialLink,
                profileImage: image
            )
            delegate?.didDiscoverPeer(peer)
        }

        if characteristic.uuid == imageUUID,
           let data = characteristic.value {
            imageDataCache[peripheral.identifier] = data
        }
    }
}

extension BluetoothManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        updateState()
    }

    func peripheralManager(_ peripheral: CBPeripheralManager,
                           didReceiveRead request: CBATTRequest) {
        guard let peer = profile else { return }

        if request.characteristic.uuid == imageUUID {
            if let data = peer.profileImageData {
                let range = Int(request.offset)..<data.count
                request.value = data.subdata(in: range)
            }
        } else if request.characteristic.uuid == infoUUID {
            request.value = infoCharacteristic.value
        }

        peripheral.respond(to: request, withResult: .success)
    }
}


