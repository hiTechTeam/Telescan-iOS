import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    @State private var selectedID: String? = nil
    @State private var showProfileSheet = false
    
    var body: some View {
        ZStack {
            Color.tsBackground.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                // MARK: - SCANNING ENABLED
                if peopleViewModel.isScanningEnabled {
                    
                    if peopleViewModel.devices.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "wave.3.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                            
                            Text("""
                                 Scanning is active…
                                 Nearby people will appear here. Keep the app open — background scanning is not available.
                                 """)
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        }
                        .frame(maxWidth: 320, maxHeight: .infinity)
                        
                    } else {
                        List {
                            ForEach(Array(peopleViewModel.devices.keys), id: \.self) { id in
                                Button {
                                    selectedID = id
                                    showProfileSheet = true
                                } label: {
                                    PeopleRowContent(id: id)
                                }
                                .onAppear {
                                    Task { await peopleViewModel.loadUserIfNeeded(tgID: id) }
                                }
                            }
                        }
                    }
                    
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "pause.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        Text("""
                             Scanning is turned off.
                             Enable scanning in the app to see nearby people. Background scanning is not available.
                             """)
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    }
                    .frame(maxWidth: 320, maxHeight: .infinity)
                }
            }
        }
        // MARK: - Sheet
        .sheet(isPresented: $showProfileSheet) {
            if let id = selectedID {
                ProfileSheetView(id: id)
                    .environmentObject(peopleViewModel)
            }
        }
    }
}

struct PeopleRowContent: View {
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    let id: String
    
    var body: some View {
        HStack(spacing: 12) {
            
            if let user = peopleViewModel.userCache[id],
               let url = user.photoURL,
               let imageURL = URL(string: url) {
                
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 56, height: 56)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(peopleViewModel.userCache[id]?.tgName ?? "Unknown")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                
                Text(peopleViewModel.userCache[id]?.tgUsername ?? "")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            if let meters = peopleViewModel.distances[id] {
                Text("\(meters) m")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.trailing, 20)
            }
        }
    }
}


struct ProfileSheetView: View {
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    let id: String
    
    var body: some View {
        VStack {
            Spacer()
            
            // Фото 360
            if let user = peopleViewModel.userCache[id],
               let url = user.photoURL,
               let imageURL = URL(string: url) {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 360, height: 360)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 360, height: 360)
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 360, height: 360)
            }
            
            Spacer()
            
            // Имя и username
            VStack(spacing: 4) {
                Text(peopleViewModel.userCache[id]?.tgName ?? "Unknown")
                    .font(.title)
                    .bold()
                
                Text(peopleViewModel.userCache[id]?.tgUsername ?? "")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tsBackground)
    }
}
