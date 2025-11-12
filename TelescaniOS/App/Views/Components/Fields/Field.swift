import SwiftUI

struct Field: View {
    @StateObject private var viewModel = FieldViewModel()
    
    @Binding var text: String
    var placeholder: String
    
    let fieldWidth: CGFloat = 360
    let fieldHeight: CGFloat = 46
    let cornerRadius: CGFloat = 13
    let paddingH: CGFloat = 13
    let lineWidth: CGFloat = 1
    var paddingLeading: CGFloat { fieldWidth / 2 }

    var body: some View {
        ZStack {
            TextField(placeholder, text: $text)
                .padding(.horizontal, paddingH)
                .frame(width: fieldWidth, height: fieldHeight)
                .background(Color.tField)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.gray, lineWidth: lineWidth)
                )
                .foregroundColor(.primary)
                .font(.system(size: viewModel.fontSizeCode))
                .tint(.blue)
                .textInputAutocapitalization(.characters)
                .onChange(of: text) { _, newValue in
                    viewModel.handleTextChange(newValue.uppercased())
                }

            if viewModel.showWarning {
                Text(Inc.warningCharactersEight)
                    .foregroundColor(.gray)
                    .font(.system(size: viewModel.fontSizeSmall))
                    .frame(width: fieldWidth, height: fieldHeight, alignment: .center)
                    .padding(.leading, paddingLeading)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.showWarning)
    }
}
