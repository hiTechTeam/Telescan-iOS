import SwiftUI
import CoreBluetooth

// MARK: - ViewModel
final class PeopleViewModel: ObservableObject, BLEManagerDelegate {
    @Published var devices: [String: Int] = [:] // [ID: RSSI]
    
    private let validIDPattern = #"^\d+$"#
    
    init() {
        BLEManager.shared.delegate = self
    }
    
    func didDiscoverDevice(id: String, rssi: Int) {
        guard id.range(of: validIDPattern, options: .regularExpression) != nil else { return }
        DispatchQueue.main.async { self.devices[id] = rssi }
    }
    
    func didUpdateDevice(id: String, rssi: Int) {
        guard id.range(of: validIDPattern, options: .regularExpression) != nil else { return }
        DispatchQueue.main.async { self.devices[id] = rssi }
    }
    
    func didLoseDevice(id: String) {
        guard id.range(of: validIDPattern, options: .regularExpression) != nil else { return }
        DispatchQueue.main.async { self.devices.removeValue(forKey: id) }
    }
    
    func didFail(with error: Error) {
        print("BLE error: \(error)")
    }
    
    func clearDevices() {
        DispatchQueue.main.async { self.devices.removeAll() }
    }
    
    // MARK: - RSSI -> Метры
    func distanceFromRSSI(_ rssi: Int, txPower: Int = -59, n: Double = 2) -> Int {
        let ratio = Double(txPower - rssi) / (10 * n)
        let distance = pow(10.0, ratio)
        return max(1, Int(distance.rounded()))
    }
}

// MARK: - View
struct PeopleView: View {
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    
    var body: some View {
        ZStack {
            Color.tsBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                if peopleViewModel.devices.isEmpty {
                    Text("No devices nearby")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(Array(peopleViewModel.devices.keys), id: \.self) { id in
                            HStack {
                                Text(id)
                                Spacer()
                                if let rssi = peopleViewModel.devices[id] {
                                    let meters = peopleViewModel.distanceFromRSSI(rssi)
                                    Text("\(meters) m")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Color.tsBackground)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.tsBackground)
                }
            }
        }
        .onAppear {
            BLEManager.shared.startScanning()
        }
        .onDisappear {
            BLEManager.shared.stopScanning()
        }
    }
}
