import SwiftUI
import PhotosUI

struct ContentView: View {
    @AppStorage("selectedTab") private var selectedTab = 1
    @AppStorage("isScanningEnabled") private var isScanningEnabled = false
    @State private var showSettings = false
    
    @StateObject private var peerStore = PeerStore()
    @StateObject private var bluetoothManager = BluetoothManager()
    @StateObject private var profileStore = ProfileStore()
    
    @State private var profileImage: UIImage? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                PeopleNearView(
                    profileImage: $profileImage,
                    profileName: profileStore.name,
                    socialName: profileStore.socialName,
                    socialLink: profileStore.socialLink
                )
                .environmentObject(peerStore)
                .environmentObject(bluetoothManager)
                .onChange(of: isScanningEnabled) { oldValue, newValue in
                    if newValue {
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
                .navigationTitle("Люди рядом")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { showSettings = true } label: {
                            Image(systemName: "tornado")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                    }
                }
            }
            
            .tabItem {
                if isScanningEnabled {
                    Label("Рядом", systemImage: "shareplay")
                } else {
                    Label("", systemImage: "shareplay.slash")
                }
            }
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
            SettingsView()
                .presentationDetents([.fraction(0.33)])
                .presentationDragIndicator(.visible)
        }
    }
}
