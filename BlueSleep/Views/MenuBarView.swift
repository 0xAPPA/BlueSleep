import SwiftUI

struct MenuBarView: View {
    @StateObject private var viewModel = MenuBarViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Toggle("Enable Protection", isOn: $viewModel.settings.isEnabled)

            Divider()

            Text("Protection Mode")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Mode", selection: $viewModel.settings.protectionModeRaw) {
                ForEach(ProtectionMode.allCases, id: \.rawValue) { mode in
                    Text(mode.title).tag(mode.rawValue)
                }
            }
            .labelsHidden()
            .pickerStyle(.inline)

            Divider()

            Toggle("Auto-reconnect on Wake", isOn: $viewModel.settings.autoReconnect)

            Toggle("Launch at Login", isOn: Binding(
                get: { viewModel.settings.launchAtLogin },
                set: { viewModel.setLaunchAtLogin($0) }
            ))

            Divider()

            Button("Quit") {
                viewModel.quit()
            }
            .keyboardShortcut("q")
        }
        .padding(8)
    }
}
