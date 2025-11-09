import SwiftUI

extension Telescan {
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
