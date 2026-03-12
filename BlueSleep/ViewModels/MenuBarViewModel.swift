import Foundation
import Combine
import ServiceManagement
import AppKit

@MainActor
final class MenuBarViewModel: ObservableObject {
    @Published var settings = AppSettings.shared

    private let bluetoothService = BluetoothService.shared
    private let sleepMonitor = SleepWakeMonitor()
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSleepWakeHandlers()
        syncLaunchAtLogin()
    }

    private func setupSleepWakeHandlers() {
        sleepMonitor.onSleep = { [weak self] in
            guard let self else { return }
            Task { @MainActor in
                if self.settings.isEnabled {
                    self.bluetoothService.applyProtection(mode: self.settings.protectionMode)
                }
            }
        }

        sleepMonitor.onWake = { [weak self] in
            guard let self else { return }
            Task { @MainActor in
                if self.settings.isEnabled {
                    self.bluetoothService.restoreState(
                        mode: self.settings.protectionMode,
                        autoReconnect: self.settings.autoReconnect
                    )
                }
            }
        }
    }

    func setLaunchAtLogin(_ enabled: Bool) {
        settings.launchAtLogin = enabled
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to update login item: \(error)")
        }
    }

    private func syncLaunchAtLogin() {
        let status = SMAppService.mainApp.status
        settings.launchAtLogin = (status == .enabled)
    }

    func quit() {
        NSApp.terminate(nil)
    }
}
