import SwiftUI
import CoreBluetooth

struct ScanToggle: View {
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    @Binding var isToggleOn: Bool
    
    
    private let frameWidth: CGFloat = 360
    private let frameHeight: CGFloat = 46
    private let cornerRadius: CGFloat = 13
    private let paddingHorizontal: CGFloat = 14
    private let imageSize: CGFloat = 28
    private let tgIdKey = "tg_id"
    
    @State private var showBluetoothAlert = false
    private let bleManager = BLEManager.shared
    
    var body: some View {
        HStack {
            Image.iconEye
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
            
            Toggle(Inc.scanning, isOn: $isToggleOn)
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .onChange(of: isToggleOn) { _, newValue in
                    guard let tgId = UserDefaults.standard.object(forKey: tgIdKey) as? Int else { return }
                    if newValue {
                        if bleManager.isBluetoothAvailable {
                            bleManager.startAdvertising(id: String(tgId))
                        } else {
                            showBluetoothAlert = true
                        }
                    } else {
                        bleManager.stopAdvertising()
                        peopleViewModel.clearDevices()
                    }
                }
                .alert("Включите Bluetooth", isPresented: $showBluetoothAlert) {
                    Button("OK") { }
                }
        }
        .padding(.horizontal, paddingHorizontal)
        .frame(width: frameWidth, height: frameHeight)
        .background(Color.grOne)
        .cornerRadius(cornerRadius)
    }
}
