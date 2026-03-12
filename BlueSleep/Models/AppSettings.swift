import Foundation
import SwiftUI

final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @AppStorage("isEnabled") var isEnabled: Bool = true
    @AppStorage("protectionMode") var protectionModeRaw: Int = ProtectionMode.blockNew.rawValue
    @AppStorage("launchAtLogin") var launchAtLogin: Bool = false
    @AppStorage("autoReconnect") var autoReconnect: Bool = true

    var protectionMode: ProtectionMode {
        get { ProtectionMode(rawValue: protectionModeRaw) ?? .blockNew }
        set { protectionModeRaw = newValue.rawValue }
    }

    private init() {}
}
