import SwiftUI

struct PeerItemView: View {
    let peer: UserPeer
    
    var body: some View {
        VStack(spacing: 8) {
            if let image = peer.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 112, height: 112)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 112, height: 112)
                    .foregroundColor(.gray)
            }
            
            if !peer.socialName.isEmpty {
                Text(peer.socialName)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.center)
            }
            
            if !peer.socialLink.isEmpty {
                Text(peer.socialLink)
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

