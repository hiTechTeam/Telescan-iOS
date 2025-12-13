import SwiftUI
import CoreBluetooth

struct ScanToggle: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var peopleVM: PeopleViewModel
    @Binding var isScaning: Bool
    @State private var showBluetoothAlert = false
    
    private let frameWidth: CGFloat = 360
    private let frameHeight: CGFloat = 46
    private let cornerRadius: CGFloat = 13
    private let paddingHorizontal: CGFloat = 14
    private let imageSize: CGFloat = 28
    private let tgIdKey: String = GlobalVars.tgIdKey
    private let bleManager = BLEManager.shared
    
    private var iconEye: some View {
        Image.iconEye
            .resizable()
            .scaledToFit()
            .frame(width: imageSize, height: imageSize)
    }
    
    private var scanToggle: some View {
        Toggle(Inc.Scanning.scanning.localized, isOn: $isScaning)
            .toggleStyle(SwitchToggleStyle(tint: .green))
            .onChange(of: isScaning) { _, newValue in
                
                peopleVM.toggleScanning(newValue)
                coordinator.isScaning = newValue
                UserDefaults.standard.set(newValue, forKey: Keys.isScaning.rawValue)
                
                guard let tgId = UserDefaults.standard.object(forKey: tgIdKey) as? Int else { return }
                
                if newValue {
                    if bleManager.isBluetoothAvailable {
                        bleManager.startAdvertising(id: String(tgId))
                    } else {
                        showBluetoothAlert = true
                    }
                } else {
                    bleManager.stopAdvertising()
                }
            }
            .alert(Inc.Alerts.turnOnBLE.localized, isPresented: $showBluetoothAlert) {
                Button(Inc.Common.ok) { }
            }
    }
    
    private var scanToggleView: some View {
        HStack {
            iconEye
            scanToggle
        }
        .padding(.horizontal, paddingHorizontal)
        .frame(width: frameWidth, height: frameHeight)
        .background(Color.grOne)
        .cornerRadius(cornerRadius)
    }
    
    var body: some View {
        scanToggleView
    }
}
