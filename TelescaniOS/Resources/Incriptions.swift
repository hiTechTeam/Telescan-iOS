struct Inc {
    static let people = "People"
    static let profile = "Profile"
    static let placeCode = "Code"
    static let enterCode = "Enter the code"
    static let tgUsername = "Telegram username"
    static let usernamePlaceholder = "@_"
    static let code = "Code"
    static let currentCode = "Current code: "
    static let registration = "Registration"
    static let goNext = "Next"
    static let go = "Go"
    static let incorrectCode = "Couldn't find a telegram username"
    static let warningCharactersEight = "maximum of 8 characters"
    static let telescanBot = "Telescan_bot"
    
    static let takePhoto: String = "Take Photo"
    static let galleryPhoto: String = "Choose from Gallery"
    static let deletePhoto: String = "Delete Photo"
    static let cancel: String = "Cancel"
    static let photoOptions: String = "Photo Options"
    
    static let regDescription = "Enter the code that our bot sand you and the app can detect you telegram @username"
    static let scanning = "Scanning"
    static let poweredBy = "Powered by Telegram"
    static let shareUtg = "Share you're profile"
    static let logIn = "Log in"
    static let start = "Connect with Telegram"
    static let Telescan = "Telescan"
    static let Welcome = "Welcome to"
    static let aboutOnBoardingMsg = "Telescan lets you instantly find and share Telegram profiles with people nearby. It’s your local connector for quick and secure connections."
    static let shortOnboardingMsg = "Share you Telegram with people around you."
    static let scanToggleDescription = "Turn on Bluetooth scanning so that you can see the people around you, and also allow this device to do this in your device settings."
    
    static let profileSettingsDescription = "We use telegram to communicate, you can make change profile data in telegram profile."
}

struct IncLogos {
    static let shareplay = "shareplay"
    static let personFillViewwfinder = "person.fill.viewfinder"
}

struct Links {
    static let telescanBot = "https://t.me/tgtelescan_bot"
    static let telescanApiTunnel = "https://etctk-172-245-109-174.a.free.pinggy.link/v1/code/"
    static let telescanApiLocal = "http:/localhost:80/v1/code/"
}

enum SelectedTab: Int {
    case near = 0
    case profile = 1
}

