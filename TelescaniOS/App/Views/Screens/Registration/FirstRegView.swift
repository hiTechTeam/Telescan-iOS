import SwiftUI

struct FirstRegView: View {
    
    // MARK: - Env
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // MARK: - Binds
    @Binding var onStart: Bool
    
    // MARK: - Сonstants
    private let gradientSize: CGFloat = 750
    private let gradientOffsetX: CGFloat = -80
    private let gradientOffsetY: CGFloat = 560
    private let containerSpacing: CGFloat = 24
    private let welcomeFontSize: CGFloat = 28
    private let welcomeOpacity: CGFloat = 0.5
    private let welcomeFrameWidth: CGFloat = 360
    private let welcomeFrameHeight: CGFloat = 32
    private let welcomePaddingLeading: CGFloat = 32
    private let welcomeOffsetY: CGFloat = 24
    private let telescanFontSize: CGFloat = 56
    private let telescanSpacing: CGFloat = 4
    private let iconSize: CGFloat = 110
    private let contentFrameWidth: CGFloat = 360
    private let aboutFontSize: CGFloat = 36
    private let shareFontSize: CGFloat = 14
    private let zOne: Double = 1
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color(colorScheme == .dark ? Color.dark : Color.bl2)
                    .ignoresSafeArea()
                
                Image(colorScheme == .dark ? .gradientCircleDark : .gradientCircleLight)
                    .resizable()
                    .scaledToFill()
                    .frame(width: gradientSize, height: gradientSize)
                    .offset(x: gradientOffsetX, y: gradientOffsetY)
                    .ignoresSafeArea()
                    .zIndex(.zero)
                
                VStack(spacing: containerSpacing) {
                    VStack(alignment: .center) {
                        
                        Spacer()
                        
                        VStack(spacing: telescanSpacing) {
                            Text(Inc.Welcome)
                                .font(.system(size: welcomeFontSize, weight: .heavy))
                                .foregroundColor(colorScheme == .dark ? Color.bl2 : Color.white)
                                .opacity(welcomeOpacity)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Text(Inc.Telescan)
                                    .font(.system(size: telescanFontSize, weight: .heavy))
                                    .foregroundColor(colorScheme == .dark ? Color.bl2 : Color.white)
                                Spacer()
                                Image.tsIcon100
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: iconSize, height: iconSize)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Text(Inc.shortOnboardingMsg)
                                .font(.system(size: aboutFontSize, weight: .semibold))
                                .foregroundColor(colorScheme == .dark ? Color.bl2 : Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(width: contentFrameWidth)
                        
                        Spacer()
                        
                    }
                    .frame(width: welcomeFrameWidth)
                    
                    Text(Inc.letsGo)
                        .font(.system(size: shareFontSize, weight: .regular))
                        .foregroundColor(colorScheme == .dark ? Color.bl2 : Color.white)
                        .frame(width: contentFrameWidth)
                    
                    StartButton(title: Inc.start) {
                        onStart = true
                    }
                    
                }
                .zIndex(zOne)
                
            }
            .navigationDestination(isPresented: $onStart) {
                RegView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
