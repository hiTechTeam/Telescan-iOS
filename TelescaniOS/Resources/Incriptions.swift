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
        
        static let copiedSheet: String = "copied_sheet"
        // EN: Copied
        // RU: Скопировано
        
        static let nearby: String = "nearby"
        // EN: Nearby
        // RU: Рядом
        
        static let ok: String = "Ok"
        static let Telescan: String = "Telescan"
    }
    
    // MARK: - Tabs
    struct Tabs {
        static let chats: String = "Chats"
        // EN: Chats
        // RU: Чаты
        
        static let peopleNearby: String = "peopleNearby"
        // EN: People nearby
        // RU: Люди рядом
        
        static let people: String = "people"
        // EN: People
        // RU: Люди
        
        static let profile: String = "profile"
        // EN: Profile
        // RU: Профиль
        
        static let metTitle: String = "metTitle"
        // EN: Met recently
        // RU: Виделись недавно
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
        
        
        static let justTurnScaning: String = "justTurnScaning"
        // EN: Turn on scaning
        // RU: Включите сканирование
        
        static let scanToggleDescription: String = "scanToggleDescription"
        // EN: Turn on Bluetooth scanning so that you can see people around you.
        // RU: Включите Bluetooth-сканирование, чтобы видеть людей рядом.
        
        static let turnedOffScanning: String = "turnedOffScaning"
        // EN: Scanning is turned off. Enable scanning in the app to see nearby people. Background scanning is not available.
        // RU: Сканирование отключено. Включите сканирование в приложении, чтобы видеть людей, находящихся поблизости. Фоновое сканирование недоступно.
        
        static let noPeopleNeaby: String = "noPeopleNearby"
        // EN: Scanning is active… Nearby people will appear here. Keep the app open - background scanning is not available.
        // Ru: Сканирование запущено… Здесь будут отображаться люди, находящиеся поблизости. Оставьте приложение открытым - фоновое сканирование недоступно.
        
        static let scanAlertText: String = "scanAlertText"
        // EN: To switch over, you need to enable scanning mode.
        // RU: Для перехода необходимо включить режим сканирования.
        
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
        
        static let version = "version"
        // EN: Version
        // RU: Версия
        
        static let copyUsername = "copyUsername"
        // EN: Copy and past username in Telegram search field
        // RU: Скопируйте и вставьте в поле поиска Telegram
        
        static let licenseMIT = "licenseMIT"
        // EN: License: MIT
        // RU: Лицензия: MIT
        
        static let openSourceText = "openSourceText"
        // EN: This is an open-source project developed in the open and driven by the community. If you’re interested in contributing, shaping the architecture, improving features, or sharing     your ideas, you’re very welcome to join the development. Any contribution — from feedback to pull requests, is appreciated and helps the project grow.
        // RU: Проект развивается как open-source, и мы открыты к сообществу. Если вам интересно поучаствовать в создании продукта, повлиять на архитектуру и функциональность или предложить       свои идеи, вы можете свободно подключиться к разработке. Любой вклад, от замечаний до pull request’ов, приветствуется и влияет на развитие проекта.
        
        static let currentVersion = " 0.0.0"
    }
}

struct IncLogos {
    static let shareplay = "shareplay"
    static let personFillViewwfinder = "person.fill.viewfinder"
}

struct Links {
    
    static let local = "http://localhost:80"
    static let origin = "https://bwfyw-206-217-134-170.a.free.pinggy.link"
    
    static let telescanBot = "https://t.me/tgtelescan_bot"
    static let telescanApiTunnel =  origin + "/v1/code/"
    static let telescanApiGetuser = origin + "/v1/users/"
    static let telescanApiUploadPhoto = origin + "/v1/users/upload-photo"
    static let telescanApiUpdatePhoto = origin + "/v1/users/update-photo"
    static let telescanApiDeletePhoto = origin + "/v1/users/delete-photo"
    
}

enum SelectedTab: Int {
    case near = 0
    case localChats = 2
    case profile = 1
}

enum Keys: String {
    case tgIdKey = "tg_id"
    case tgNameKey = "tgName"
    case userCodeKey = "userCode"
    case usernameKey = "username"
    case photoS3URLKey = "photoS3Url"
    case hashedCodeKey = "hashedCode"
    case cleanCodeKey = "cleanCode"
    case isScaning = "isScaning"
    case isReg = "isReg"
}


enum HTTPStatus: Int {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
}

enum HTTPMethods: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
