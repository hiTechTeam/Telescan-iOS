import SwiftUI

struct CodeSpace: View {
    @Binding var codeStatus: Bool?
    @FocusState var isFocused: Bool
    
    @State private var code: String = ""
    @State private var username: String? = nil
    @State private var didReactToFullCode = false
    
    
    let frameWidth: CGFloat = 360
    let topPadding: CGFloat = 10
    let codeCount: Int = 8
    
    let text: String = Inc.regDescription
    
    private func checkCode(_ input: String) {
        
        if input.count < codeCount {
            didReactToFullCode = false
            codeStatus = nil
            username = nil
            return
        }
        
        guard !didReactToFullCode else { return }
        didReactToFullCode = true
        
        if input.count == codeCount {
            if input == "YYYYYYYY" {
                codeStatus = true
                username = "@ruslanrocketman1"
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            } else {
                username = nil
                codeStatus = false
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        } else {
            codeStatus = true
            username = nil
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 0) {
                FieldTitle(text: Inc.enterCode)
                Field(text: $code, placeholder: Inc.code)
                    .focused($isFocused)
                    .onChange(of: code) { _, newValue in checkCode(newValue)}
            }
            .padding(.top, topPadding)
            
            VStack(spacing: 0) {
                FieldTitle(text: Inc.tgUsername)
                UsernamePlaceholder(username: username, codeStatus: codeStatus)
                
            }
            
            RegDescription(text: text)
        }
        .frame(width: frameWidth)
        
        
    }
}


