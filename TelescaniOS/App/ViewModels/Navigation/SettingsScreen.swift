import SwiftUI

struct SettingsView: View {
    @Binding var isScanningEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "wave.3.up")
                        .font(.title2)
                    Text("Сканирование")
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
