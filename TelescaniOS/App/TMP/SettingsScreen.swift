import SwiftUI

struct SettingsView: View {
    @AppStorage("isScanningEnabled") private var isScanningEnabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Text("Принимать и делиться")
                        .font(.headline)
                }
                Spacer()
                Toggle("", isOn: $isScanningEnabled)
                    .labelsHidden()
            }
            .padding()

            Text("Когда функция активна, приложение автоматически ищет людей поблизости и отображает их на экране.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 24)
    }
}
