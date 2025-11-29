import Foundation

public protocol BLEManagerDelegate: AnyObject {
    func didDiscoverDevice(id: String, rssi: Int)
    func didUpdateDevice(id: String, rssi: Int)
    func didLoseDevice(id: String)
    func didFail(with error: Error)
}

protocol BLEManagerProtocol {
    
    var delegate: BLEManagerDelegate? { get set }
    
    // SCAN
    func startScanning()
    func stopScanning()

    // ADVERTISE
    func startAdvertising(id: String)
    func stopAdvertising()

    func reset()
    
    var isBluetoothAvailable: Bool { get }
}
