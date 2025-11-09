<<<<<<< HEAD
//import Foundation
//import CoreBluetooth
//import UIKit
//
//protocol BluetoothManagerDelegate: AnyObject {
//    func didDiscoverPeer(_ peer: UserPeer)
//}
//
//final class BluetoothManager: NSObject, ObservableObject {
//    @Published var state: CBManagerState = .unknown
//    @Published var isScanning = false
//
//    private var central: CBCentralManager!
//    private var peripheral: CBPeripheralManager!
//
//    weak var delegate: BluetoothManagerDelegate?
//
//    private let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-1234567890AB")
//    private let infoUUID = CBUUID(string: "11111111-1111-1111-1111-111111111111")
//    private let imageUUID = CBUUID(string: "22222222-2222-2222-2222-222222222222")
//
//    private var profile: UserPeer?
//    private var infoCharacteristic: CBMutableCharacteristic!
//    private var imageCharacteristic: CBMutableCharacteristic!
//
//    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]
//    private var imageDataCache: [UUID: Data] = [:]
//    private var incomingImageBuffer: [UUID: Data] = [:]
//
//    private let mtu = 180 // размер чанка для передачи фото
//
//    override init() {
//        super.init()
//        central = CBCentralManager(delegate: self, queue: .main)
//        peripheral = CBPeripheralManager(delegate: self, queue: .main)
//    }
//
//    func start(peer: UserPeer) {
//        profile = peer
//        isScanning = true
//        configurePeripheral()
//        updateState()
//    }
//
//    func stop() {
//        isScanning = false
//        peripheral.stopAdvertising()
//        central.stopScan()
//    }
//}
//
//// MARK: - Peripheral (Advertising)
//
//private extension BluetoothManager {
//    func configurePeripheral() {
//        guard let peer = profile else { return }
//
//        let peerInfo = PeerInfo(
//            id: peer.id,
//            socialName: peer.socialName,
//            socialLink: peer.socialLink
//        )
//
//        let infoData = try? JSONEncoder().encode(peerInfo)
//
//        infoCharacteristic = CBMutableCharacteristic(
//            type: infoUUID,
//            properties: [.read],
//            value: infoData,
//            permissions: [.readable]
//        )
//
//        imageCharacteristic = CBMutableCharacteristic(
//            type: imageUUID,
//            properties: [.notify],
//            value: nil,
//            permissions: [.readable]
//        )
//
//        let service = CBMutableService(type: serviceUUID, primary: true)
//        service.characteristics = [infoCharacteristic, imageCharacteristic]
//
//        peripheral.removeAllServices()
//        peripheral.add(service)
//
//        startAdvertising()
//    }
//
//    func startAdvertising() {
//        guard let peer = profile else { return }
//        peripheral.startAdvertising([
//            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
//            CBAdvertisementDataLocalNameKey: peer.socialName
//        ])
//    }
//
//    func sendImageChunks() {
//        guard let data = profile?.profileImageData else { return }
//        var offset = 0
//        while offset < data.count {
//            let chunkSize = min(mtu, data.count - offset)
//            let chunk = data.subdata(in: offset..<offset + chunkSize)
//            _ = peripheral.updateValue(chunk, for: imageCharacteristic, onSubscribedCentrals: nil)
//            offset += chunkSize
//        }
//    }
//}
//
//// MARK: - Central (Scanning)
//
//private extension BluetoothManager {
//    func startScanning() {
//        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
//    }
//
//    func connect(_ peripheral: CBPeripheral) {
//        discoveredPeripherals[peripheral.identifier] = peripheral
//        peripheral.delegate = self
//        central.connect(peripheral)
//    }
//}
//
//// MARK: - CBCentralManagerDelegate & CBPeripheralDelegate
//
//extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        state = central.state
//        updateState()
//    }
//
//    private func updateState() {
//        guard isScanning else { return }
//        if central.state == .poweredOn { startScanning() }
//        if peripheral.state == .poweredOn { startAdvertising() }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
//                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        guard discoveredPeripherals[peripheral.identifier] == nil else { return }
//        connect(peripheral)
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        peripheral.discoverServices([serviceUUID])
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else { return }
//        for s in services where s.uuid == serviceUUID {
//            peripheral.discoverCharacteristics([infoUUID, imageUUID], for: s)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral,
//                    didDiscoverCharacteristicsFor service: CBService,
//                    error: Error?) {
//        guard let chars = service.characteristics else { return }
//        for c in chars {
//            if c.uuid == infoUUID {
//                peripheral.readValue(for: c)
//            } else if c.uuid == imageUUID {
//                peripheral.setNotifyValue(true, for: c)
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral,
//                    didUpdateValueFor characteristic: CBCharacteristic,
//                    error: Error?) {
//        guard error == nil else { return }
//
//        if characteristic.uuid == infoUUID,
//           let data = characteristic.value,
//           let info = try? JSONDecoder().decode(PeerInfo.self, from: data) {
//            let image = incomingImageBuffer[peripheral.identifier].flatMap { UIImage(data: $0) }
//            let peer = UserPeer(
//                id: info.id,
//                socialName: info.socialName,
//                socialLink: info.socialLink,
//                profileImage: image
//            )
//            delegate?.didDiscoverPeer(peer)
//        }
//
//        if characteristic.uuid == imageUUID,
//           let chunk = characteristic.value {
//            if incomingImageBuffer[peripheral.identifier] == nil {
//                incomingImageBuffer[peripheral.identifier] = chunk
//            } else {
//                incomingImageBuffer[peripheral.identifier]?.append(chunk)
//            }
//        }
//    }
//}
//
//// MARK: - CBPeripheralManagerDelegate
//
//extension BluetoothManager: CBPeripheralManagerDelegate {
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        updateState()
//    }
//
//    func peripheralManager(_ peripheral: CBPeripheralManager,
//                           didSubscribeTo characteristic: CBCharacteristic) {
//        if characteristic.uuid == imageUUID {
//            sendImageChunks()
//        }
//    }
//}

=======
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
import Foundation
import CoreBluetooth
import UIKit

protocol BluetoothManagerDelegate: AnyObject {
    func didDiscoverPeer(_ peer: UserPeer)
}

final class BluetoothManager: NSObject, ObservableObject {
    @Published var state: CBManagerState = .unknown
    @Published var isScanning = false
<<<<<<< HEAD
    
    weak var delegate: BluetoothManagerDelegate?
    
    private var central: CBCentralManager!
    private var peripheral: CBPeripheralManager!
    
    private let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-1234567890AB")
    private let infoUUID = CBUUID(string: "11111111-1111-1111-1111-111111111111")
    private let imageUUID = CBUUID(string: "22222222-2222-2222-2222-222222222222")
    
    private var profile: UserPeer?
    private var infoCharacteristic: CBMutableCharacteristic!
    private var imageCharacteristic: CBMutableCharacteristic!
    
    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]
    
    // для приёма изображения
    private var incomingImageLength: [UUID: Int] = [:]
    private var incomingImageBuffer: [UUID: Data] = [:]
    
    // для отправки изображения
    private var outgoingImageChunks: [Data] = []
    
=======

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

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main)
        peripheral = CBPeripheralManager(delegate: self, queue: .main)
    }
<<<<<<< HEAD
    
=======

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    func start(peer: UserPeer) {
        profile = peer
        isScanning = true
        configurePeripheral()
        updateState()
    }
<<<<<<< HEAD
    
=======

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
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
<<<<<<< HEAD
        
        let info = PeerInfo(id: peer.id, socialName: peer.socialName, socialLink: peer.socialLink)
        let infoData = try? JSONEncoder().encode(info)
        
=======

        let peerInfo = PeerInfo(
            id: peer.id,
            socialName: peer.socialName,
            socialLink: peer.socialLink,
            profileImageData: nil 
        )

        let infoData = try? JSONEncoder().encode(peerInfo)

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
        infoCharacteristic = CBMutableCharacteristic(
            type: infoUUID,
            properties: [.read],
            value: infoData,
            permissions: [.readable]
        )
<<<<<<< HEAD
        
        imageCharacteristic = CBMutableCharacteristic(
            type: imageUUID,
            properties: [.notify],
            value: nil,
            permissions: [.readable]
        )
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [infoCharacteristic, imageCharacteristic]
        
        peripheral.removeAllServices()
        peripheral.add(service)
        
        startAdvertising()
    }
    
=======

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

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    func startAdvertising() {
        guard let peer = profile else { return }
        peripheral.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: peer.socialName
        ])
    }
<<<<<<< HEAD
    
    func prepareImageChunks() {
        outgoingImageChunks.removeAll()
        guard let data = profile?.profileImageData else { return }
        
        // первый chunk — длина изображения (UInt32)
        var lengthBytes = withUnsafeBytes(of: UInt32(data.count).bigEndian, Array.init)
        outgoingImageChunks.append(Data(lengthBytes))
        
        let mtu = 150
        var offset = 0
        while offset < data.count {
            let chunkSize = min(mtu, data.count - offset)
            outgoingImageChunks.append(data.subdata(in: offset..<offset + chunkSize))
            offset += chunkSize
        }
    }
    
    func sendNextChunk() {
        guard !outgoingImageChunks.isEmpty else { return }
        let chunk = outgoingImageChunks[0]
        if peripheral.updateValue(chunk, for: imageCharacteristic, onSubscribedCentrals: nil) {
            outgoingImageChunks.removeFirst()
        }
    }
=======
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
}

// MARK: - Central (Scanning)

private extension BluetoothManager {
    func startScanning() {
<<<<<<< HEAD
        central.scanForPeripherals(withServices: [serviceUUID])
    }
    
=======
        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    func connect(_ peripheral: CBPeripheral) {
        discoveredPeripherals[peripheral.identifier] = peripheral
        peripheral.delegate = self
        central.connect(peripheral)
    }
<<<<<<< HEAD
}

// MARK: - CBCentralManagerDelegate & CBPeripheralDelegate
=======

    func readImage(for peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.readValue(for: characteristic)
    }
}

// MARK: - Delegate Implementations
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        state = central.state
        updateState()
    }
<<<<<<< HEAD
    
=======

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    private func updateState() {
        guard isScanning else { return }
        if central.state == .poweredOn { startScanning() }
        if peripheral.state == .poweredOn { startAdvertising() }
    }
<<<<<<< HEAD
    
=======

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard discoveredPeripherals[peripheral.identifier] == nil else { return }
        connect(peripheral)
    }
<<<<<<< HEAD
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }
    
=======

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for s in services where s.uuid == serviceUUID {
            peripheral.discoverCharacteristics([infoUUID, imageUUID], for: s)
        }
    }
<<<<<<< HEAD
    
=======

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let chars = service.characteristics else { return }
        for c in chars {
            if c.uuid == infoUUID {
                peripheral.readValue(for: c)
            } else if c.uuid == imageUUID {
<<<<<<< HEAD
                peripheral.setNotifyValue(true, for: c)
            }
        }
    }
    
=======
                peripheral.readValue(for: c)
            }
        }
    }

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        guard error == nil else { return }
<<<<<<< HEAD
        
        if characteristic.uuid == infoUUID,
           let data = characteristic.value,
           let info = try? JSONDecoder().decode(PeerInfo.self, from: data) {
            
            let image = incomingImageBuffer[peripheral.identifier].flatMap { UIImage(data: $0) }
=======

        if characteristic.uuid == infoUUID,
           let data = characteristic.value,
           let info = try? JSONDecoder().decode(PeerInfo.self, from: data) {
            let image = imageDataCache[peripheral.identifier].flatMap { UIImage(data: $0) }
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
            let peer = UserPeer(
                id: info.id,
                socialName: info.socialName,
                socialLink: info.socialLink,
                profileImage: image
            )
            delegate?.didDiscoverPeer(peer)
        }
<<<<<<< HEAD
        
        if characteristic.uuid == imageUUID,
           let chunk = characteristic.value {
            let uuid = peripheral.identifier
            
            // первый chunk — длина изображения
            if incomingImageLength[uuid] == nil {
                let length = chunk.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
                incomingImageLength[uuid] = Int(length)
                incomingImageBuffer[uuid] = Data()
            } else {
                incomingImageBuffer[uuid]?.append(chunk)
                
                if let expected = incomingImageLength[uuid],
                   incomingImageBuffer[uuid]?.count == expected {
                    let imageData = incomingImageBuffer[uuid]!
                    let image = UIImage(data: imageData)
                    
                    incomingImageBuffer[uuid] = nil
                    incomingImageLength[uuid] = nil
                    
                    // обновляем peer с изображением
                    if let data = characteristic.value,
                       let info = try? JSONDecoder().decode(PeerInfo.self, from: data) {
                        let peer = UserPeer(
                            id: info.id,
                            socialName: info.socialName,
                            socialLink: info.socialLink,
                            profileImage: image
                        )
                        delegate?.didDiscoverPeer(peer)
                    }
                }
            }
=======

        if characteristic.uuid == imageUUID,
           let data = characteristic.value {
            imageDataCache[peripheral.identifier] = data
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
        }
    }
}

<<<<<<< HEAD
// MARK: - CBPeripheralManagerDelegate

=======
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
extension BluetoothManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        updateState()
    }
<<<<<<< HEAD
    
    func peripheralManager(_ peripheral: CBPeripheralManager,
                           didSubscribeTo characteristic: CBCharacteristic) {
        if characteristic.uuid == imageUUID {
            prepareImageChunks()
            sendNextChunk()
        }
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        sendNextChunk()
    }
}
=======

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


>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
