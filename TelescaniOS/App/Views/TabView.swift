import SwiftUI

struct GlassTabBar: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        HStack(spacing: 0) {
            tabButton(title: "Near", index: 1)
            tabButton(title: "Met", index: 0)
        }
        .padding(4)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 44))
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.27), radius: 10)
        .padding(.horizontal)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedTab)
    }
    
    @ViewBuilder
    private func tabButton(title: String, index: Int) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                if selectedTab == index {
                    RoundedRectangle(cornerRadius: 44)
                        .fill(Color.white.opacity(0.5))
                        .frame(width: geo.size.width)
                }
                Button(action: {
                    selectedTab = index
                }) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(selectedTab == index ? .blue : .black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(height: 44)
    }
}


