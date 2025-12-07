import SwiftUI

struct Welcome: View {
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @State var onStart: Bool = false
    
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
    private let aboutFontSize: CGFloat = 30
    private let shareFontSize: CGFloat = 14
    private let zOne: Double = 1
    
    private var backroundCircle: some View {
        Image(colorScheme == .dark ? .gradientCircleDark : .gradientCircleLight)
            .resizable()
            .scaledToFill()
            .frame(width: gradientSize, height: gradientSize)
            .offset(x: gradientOffsetX, y: gradientOffsetY)
            .ignoresSafeArea()
            .zIndex(.zero)
    }
    private var mainContent: some View {
        VStack(spacing: containerSpacing) {
            VStack(alignment: .center) {
                Spacer()
                VStack(spacing: telescanSpacing) {
                    Text(Inc.Onboarding.welcomeTitle.localized)
                        .font(.system(size: welcomeFontSize, weight: .heavy))
                        .foregroundColor(
                            colorScheme == .dark ? Color.bl2 : Color.white
                        )
                        .opacity(welcomeOpacity)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text(Inc.Common.Telescan)
                            .font(
                                .system(size: telescanFontSize, weight: .heavy)
                            )
                            .foregroundColor(
                                colorScheme == .dark ? Color.bl2 : Color.white
                            )
                        Spacer()
                        Image.tsIcon100
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                    }
                    .frame(maxWidth: .infinity)
                    Text(Inc.Onboarding.shortOnboardingMsg.localized)
                        .font(.system(size: aboutFontSize, weight: .semibold))
                        .foregroundColor(
                            colorScheme == .dark ? Color.bl2 : Color.white
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: contentFrameWidth)
                Spacer()
            }
            .frame(width: welcomeFrameWidth)
            
            Text(Inc.Common.SignIn.localized)
                .font(.system(size: shareFontSize, weight: .regular))
                .foregroundColor(colorScheme == .dark ? Color.bl2 : Color.white)
                .frame(width: contentFrameWidth)
            
            StartButton(title: Inc.Onboarding.start.localized) {
                onStart = true
            }
        }
        .zIndex(zOne)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(colorScheme == .dark ? Color.dark : Color.bl2)
                    .ignoresSafeArea()
                backroundCircle
                mainContent
            }
            .navigationDestination(isPresented: $onStart) {
                AuthCode()
                    .navigationBarBackButtonHidden(true)
            }
        }
        
    }
}
