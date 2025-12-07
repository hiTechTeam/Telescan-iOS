struct Inc {
    
    // MARK: - Alerts
    struct Alerts {
        static let turnOnBLE: String = "turnOnBLE"
        // EN: Turn on Bluetooth
        // RU: Включите Bluetooth
    }
    
    // MARK: - Common
    struct Common {
        
        static let SignIn: String = "SignIn"
        // EN: Sign in
        // RU: Зарегистрироваться
        
        static let cancel: String = "cancel"
        // EN: Cancel
        // RU: Отмена
        
        static let ok: String = "Ok"
        static let Telescan: String = "Telescan"
    }
    
    // MARK: - Tabs
    struct Tabs {
        static let chats: String = "Chats"
        // EN: Chats
        // RU: Чаты
        
        static let people: String = "people"
        // EN: People
        // RU: Люди
        
        static let profile: String = "profile"
        // EN: Profile
        // RU: Профиль
    }
    
    // MARK: - Registration
    struct Registration {
        static let placeCode: String = "placeCode"
        // EN: Code
        // RU: Код
        
        static let enterCode: String = "enterCode"
        // EN: Enter code
        // RU: Введите код
        
        static let codePlaceholder: String = "codePlaceholder"
        // EN: Code
        // RU: Код
        
        static let currentCode: String = "currentCode"
        // EN: Current code:
        // RU: Текущий код:
        
        static let registration: String = "registration"
        // EN: Registration
        // RU: Регистрация
        
        static let incorrectCode: String = "incorrectCode"
        // EN: Couldn't find a telegram username
        // RU: Не удалось найти Telegram username
        
        static let warningCharactersEight: String = "warningCharactersEight"
        // EN: Maximum of 8 characters
        // RU: Максимум 8 символов
        
        static let regDescription: String = "regDescription"
        // EN: Enter the code that the bot sent so that the application can link your tg username.
        // RU: Введите код, который отправил бот, для того чтобы приложение могло привязать ваш tg username.
        
        static let tgUsername: String = "Telegram username"
        static let usernamePlaceholder: String = "@_"
    }
    
    // MARK: - Onboarding
    struct Onboarding {
        static let welcomeTitle: String = "welcome_title"
        // EN: Welcome to Telescan
        // RU: Добро пожаловать в Telescan
        
        static let aboutOnBoardingMsg: String = "aboutOnBoardingMsg"
        // EN: Telescan lets you instantly find and share profiles.
        // RU: Telescan позволяет быстро находить и обмениваться профилями.
        
        static let shortOnboardingMsg: String = "shortOnboardingMsg"
        // EN: Share your Telegram with people around you
        // RU: Делитесь Telegram с людьми рядом
        
        static let start: String = "start"
        // EN: Get started with Telegram
        // RU: Начать с Telegram
        
        static let goNext: String = "goNext"
        // EN: Next
        // RU: Далее
        
        static let go: String = "go"
        // EN: Go
        // RU: Начать
        
        static let confirmButton: String = "confirmButton"
        // EN: Confirm
        // RU: Применить
        
        static let poweredByTG: String = "poweredByTG"
    }
    
    // MARK: - Scanning
    struct Scanning {
        static let scanning: String = "scanning"
        // EN: Scanning
        // RU: Сканирование
        
        static let scanToggleDescription: String = "scanToggleDescription"
        // EN: Turn on Bluetooth scanning so that you can see people around you.
        // RU: Включите Bluetooth-сканирование, чтобы видеть людей рядом.
        
        static let turnedOffScanning: String = "turnedOffScaning"
        // EN: Scanning is turned off. Enable scanning in the app to see nearby people. Background scanning is not available.
        // RU: Сканирование отключено. Включите сканирование в приложении, чтобы видеть людей, находящихся поблизости. Фоновое сканирование недоступно.
        
        static let noPeopleNeaby: String = "noPeopleNearby"
        // EN: Scanning is active… Nearby people will appear here. Keep the app open — background scanning is not available.
        // Ru: Сканирование запущено… Здесь будут отображаться люди, находящиеся поблизости. Оставьте приложение открытым — фоновое сканирование недоступно.
    }
    
    // MARK: - Profile
    struct Profile {
        static let telescanBot: String = "Telescan_bot"
        
        static let photoOptions: String = "photoOptions"
        // EN: Photo Options
        // RU: Настройки фото
        
        static let takePhoto: String = "takePhoto"
        // EN: Take Photo
        // RU: Сделать фото
        
        static let galleryPhoto: String = "galleryPhoto"
        // EN: Choose from Gallery
        // RU: Выбрать из галереи
        
        static let deletePhoto: String = "deletePhoto"
        // EN: Delete Photo
        // RU: Удалить фото
        
        static let shareUtg: String = "shareUtg"
        // EN: Share your profile
        // RU: Поделиться профилем
        
        static let profileSettingsDescription: String = "profileSettingsDescription"
        // EN: You can change profile data in Telegram settings.
        // RU: Вы можете изменить данные профиля в настройках Telegram.
    }
    
    struct Info {
        static let Telescan = "Telescan"
        
        static let mainDescription = "info_main_description"
        // EN: The app extends Telegram's functionality and uses it as the main communication channel. Telescan enables instant exchange of Telegram usernames via Bluetooth.
        // RU: Приложение расширяет возможности Telegram и использует его как основной канал связи. Telescan позволяет мгновенно обмениваться Telegram-юзернеймами через Bluetooth.
        
        static let instantExchangeTitle = "info_instant_exchange_title"
        // EN: Instant Contact Exchange
        // RU: Мгновенный обмен контактами
        static let instantExchangeDesc = "info_instant_exchange_desc"
        // EN: Exchange contact information with other participants instantly.
        // RU: Мгновенно обменивайтесь контактной информацией с другими участниками.
        
        static let fastOfflineTitle = "info_fast_offline_title"
        // EN: Fast and Offline
        // RU: Быстро и офлайн
        static let fastOfflineDesc = "info_fast_offline_desc"
        // EN: Uses Bluetooth for offline code hash exchange.
        // RU: Использует Bluetooth для офлайн-обмена хэшами кода.
        
        static let dataProtectionTitle = "info_data_protection_title"
        // EN: Data Protection
        // RU: Защита данных
        static let dataProtectionDesc = "info_data_protection_desc"
        // EN: All data is securely protected: code hashes are stored on the server, and only the account owner can link their Telegram.
        // RU: Все данные надежно защищены: хэши кодов хранятся на сервере, и только владелец аккаунта может привязать свой Telegram.
        
        static let idealForEventsTitle = "info_ideal_events_title"
        // EN: Ideal for Events
        // RU: Идеально для мероприятий
        static let idealForEventsDesc = "info_ideal_events_desc"
        // EN: Perfect for conferences, business events, professional meetups, networking, and dating.
        // RU: Подходит для конференций, бизнес-встреч, профессиональных мероприятий, нетворкинга и знакомств.
    }
}

struct IncLogos {
    static let shareplay = "shareplay"
    static let personFillViewwfinder = "person.fill.viewfinder"
}

struct Links {
    
    static let local = "http:/localhost:80/v1/code/"
    static let tunnel = "https://pxvyz-109-252-147-215.a.free.pinggy.link"
    
    static let telescanBot = "https://t.me/tgtelescan_bot"
    static let telescanApiTunnel =  tunnel + "/v1/code/"
    static let telescanApiGetuser = tunnel + "/v1/users/"
    static let telescanApiUploadPhoto = tunnel + "/v1/users/upload-photo"
    static let telescanApiDeletePhoto = tunnel + "/v1/users/delete-photo"
    
}

enum SelectedTab: Int {
    case near = 0
    case localChats = 2
    case profile = 1
}
