import SwiftUI

struct PeopleGridView: View {
    let count: Int
    private var items: [Int] { Array(0..<count) }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(items, id: \.self) { index in
                    Button(action: {
                        print("Tapped item \(index)")
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 112, height: 112)
                                .foregroundColor(.gray)
                            
                            Text("Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 36)
            .padding(.bottom, 160)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
    }
}
