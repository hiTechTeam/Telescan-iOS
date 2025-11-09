import SwiftUI

<<<<<<< HEAD
extension Telescan {
=======
extension AirShare {
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
