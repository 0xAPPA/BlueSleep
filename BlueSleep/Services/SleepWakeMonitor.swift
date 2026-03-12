import Foundation
import Combine
import AppKit

final class SleepWakeMonitor: ObservableObject {
    @Published private(set) var isSleeping = false

    var onSleep: (() -> Void)?
    var onWake: (() -> Void)?

    init() {
        setupNotifications()
    }

    private func setupNotifications() {
        let center = NSWorkspace.shared.notificationCenter

        center.addObserver(
            self,
            selector: #selector(handleSleep),
            name: NSWorkspace.willSleepNotification,
            object: nil
        )

        center.addObserver(
            self,
            selector: #selector(handleWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }

    @objc private func handleSleep(_ notification: Notification) {
        isSleeping = true
        onSleep?()
    }

    @objc private func handleWake(_ notification: Notification) {
        isSleeping = false
        onWake?()
    }

    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
}
