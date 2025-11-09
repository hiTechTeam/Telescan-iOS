import SwiftUI

struct GlassTabBar: View {
    @Binding var selectedTab: Int
    private let titles = ["Near", "Met"]

    var body: some View {
        GeometryReader { geo in
            let tabWidth = geo.size.width / CGFloat(titles.count)
            let highlightWidth = max(0, tabWidth - 8) // внутренний отступ подсветки

            ZStack(alignment: .leading) {
                // Подсветка активного таба
                RoundedRectangle(cornerRadius: 44)
                    .fill(Color.blue)
                    .frame(width: highlightWidth, height: 48)
                    .offset(x: CGFloat(selectedTab) * tabWidth + 4) // центрируем по кнопке
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedTab)

                HStack(spacing: 0) {
                    ForEach(titles.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedTab = index
                            }
                        }) {
                            Text(titles[index])
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(selectedTab == index ? .white : Color.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.vertical, 4) // чтобы сверху и снизу был одинаковый отступ внутри кнопки
                        }
                    }
                }
            }
            .background(.thinMaterial.opacity(1.0))
            .clipShape(RoundedRectangle(cornerRadius: 44))
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.27), radius: 8)
        }
        .frame(height: 56)
        .padding(.horizontal) // внешние отступы оставляем как есть
    }
}
