import SwiftUI

@MainActor
protocol AppCoordinatorProtocol: AnyObject {
    
    func start() -> AnyView
    func completedRegistration()
    func logout() // ???: May be not need
}

