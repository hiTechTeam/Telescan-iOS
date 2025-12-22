import SwiftUI

@MainActor
protocol AppCoordinatorProtocol: AnyObject {
    
    func start() -> AnyView
    func completedRegistration()
}
