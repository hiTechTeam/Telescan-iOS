import SwiftUI

protocol AppCoordinatorProtocol: AnyObject {
    var state: AppCoordinatorState { get set}
    
    func start() -> AnyView
    func completedRegistration()
    func logout() // ???: May be not need
}

