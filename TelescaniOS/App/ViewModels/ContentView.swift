import SwiftUI
import PhotosUI

struct ContentView: View {
    @AppStorage("selectedTab") private var selectedTab = 1  // сохраняем выбранную вкладку
    @State private var showSettings = false
    @State private var isScanningEnabled = false
    
    @StateObject private var peerStore = PeerStore()
    @StateObject private var bluetoothManager = BluetoothManager()
    @StateObject private var profileStore = ProfileStore()
    
    @State private var profileImage: UIImage? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                PeopleNearView(
                    isScanningEnabled: $isScanningEnabled,
                    profileImage: $profileImage,
                    profileName: profileStore.name,
                    socialName: profileStore.socialName,
                    socialLink: profileStore.socialLink
                )
                .environmentObject(peerStore)
                .environmentObject(bluetoothManager)
                .onChange(of: isScanningEnabled) { enabled in
                    if enabled {
                        let localPeer = UserPeer(
                            id: UIDevice.current.identifierForVendor!.uuidString,
                            name: profileStore.name,
                            socialName: profileStore.socialName,
                            socialLink: profileStore.socialLink,
                            profileImage: profileImage
                        )
                        bluetoothManager.delegate = peerStore
                        bluetoothManager.start(peer: localPeer)
                    } else {
                        bluetoothManager.stop()
                    }
                }
                .navigationTitle(isScanningEnabled ? "Вокруг вас" : "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { showSettings = true } label: {
                            Image(systemName: "wave.3.up")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                    }
                }
            }
            .tabItem { Label("Рядом", systemImage: "shareplay") }
            .tag(0)
            .badge(peerStore.nearbyPeers.count)
            
            NavigationStack {
                ProfileScreen()
                    .environmentObject(profileStore)
            }
            .tabItem { Label("Профиль", systemImage: "person.fill.viewfinder") }
            .tag(1)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(isScanningEnabled: $isScanningEnabled)
                .presentationDetents([.fraction(0.33)])
                .presentationDragIndicator(.visible)
        }
    }
}
