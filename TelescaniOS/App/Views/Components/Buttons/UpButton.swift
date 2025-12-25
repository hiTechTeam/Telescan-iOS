import SwiftUI

struct UpButton: View {
    
    @ObservedObject var viewModel: CodeViewModel
    
    @State private var showSheet = false
    @FocusState private var isFocused: Bool
    
    var onUp: () -> Void
    
    private let cornerRadius: CGFloat = 13
    private let buttonSize: CGFloat = 46
    private let sheetWidth: CGFloat = 360
    private let headerHeight: CGFloat = 46
    private let topPadding: CGFloat = 24
    
    private func onTap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        onUp()
        showSheet = true
    }
    
    private func onConfirm() {
        viewModel.confirmCode()
        
        guard viewModel.codeStatus == true else { return }
        
        showSheet = false
        
        if let tgID = UserDefaults.standard.object(
            forKey: Keys.tgIdKey.rawValue
        ) as? Int {
            BLEManager.shared.restartAdvertising(id: String(tgID))
        }
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.5))
            .frame(width: buttonSize, height: buttonSize)
    }
    
    private var chevronIcon: some View {
        Image.upChevron
            .scaleEffect(0.8)
    }
    
    private var buttonContent: some View {
        ZStack {
            buttonBackground
            chevronIcon
        }
    }
    
    private var mainButton: some View {
        Button(action: onTap) {
            buttonContent
        }
    }
    
    private var sheetHeader: some View {
        HStack {
            BotButton()
        }
        .frame(width: sheetWidth, height: headerHeight, alignment: .trailing)
        .padding(.top, topPadding)
    }
    
    private var sheetContent: some View {
        VStack {
            sheetHeader
            CodeSpace()
            Spacer()
            ConfirmButton(codeStatus: $viewModel.codeStatus) {
                onConfirm()
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onTapGesture {
            isFocused = false
        }
    }
    
    // MARK: - Body
    var body: some View {
        mainButton
            .sheet(isPresented: $showSheet) {
                sheetContent
            }
    }
}
