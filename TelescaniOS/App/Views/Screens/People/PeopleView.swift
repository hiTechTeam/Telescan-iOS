import SwiftUI

struct PeopleView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    @State private var selectedID: String? = nil
    @State private var showProfileSheet = false
    
    var body: some View {
        ZStack {
            
            Color.tsBackground.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                // MARK: - SCANNING ENABLED
                if  coordinator.isScaning {
                    
                    if peopleViewModel.devices.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                Image(systemName: "wave.3.up")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.gray)
                                
                                Text(Inc.Scanning.noPeopleNeaby.localized)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 20)       // отступ сверху от таб-вью
                            .padding(.horizontal, 16) // отступ слева/справа
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        
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
                        .scrollContentBackground(.hidden)
                    }
                    
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: "pause.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.gray)
                            
                            Text(Inc.Scanning.turnedOffScanning.localized)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)       // отступ сверху от таб-вью
                        .padding(.horizontal, 16) // отступ слева/справа
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .sheet(isPresented: $showProfileSheet) {
            if let id = selectedID {
                ProfileSheetView(id: id)
                    .environmentObject(peopleViewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            
                
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
    @Environment(\.dismiss) private var dismiss
    let id: String
    
    var body: some View {
        ZStack {
            // Основной контент
            VStack {
                Spacer(minLength: 0)
                
                // Фото по центру
                if let user = peopleViewModel.userCache[id],
                   let url = user.photoURL,
                   let imageURL = URL(string: url) {
                    AsyncImage(url: imageURL) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 390, height: 390)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.primary.opacity(0.5), lineWidth: 4)
                                    .padding(-4)
                                    .opacity(0.5)
                            )
                            .shadow(radius: 10)
                    } placeholder: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 300, height: 300)
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 300, height: 300)
                }
                
                Spacer()
                
                // Нижняя часть
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(peopleViewModel.userCache[id]?.tgName ?? "Unknown")
                            .font(.title)
                            .bold()
                        HStack(spacing: 8) {
                            Text(Inc.Common.nearby.localized)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            if let meters = peopleViewModel.distances[id] {
                                Text("\(meters) m")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    if let username = peopleViewModel.userCache[id]?.tgUsername {
                        CopyUsernameField(username: username)
                    }
                }
//                .padding(.bottom, 4)
            }
            .padding(.top, 60) // отступ чтобы фото не налезало на кнопку
            
            // Кнопка закрытия поверх контента
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.gray)
                    .opacity(0.5)
            }
            .padding(.top, 20)
            .padding(.trailing, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
}
