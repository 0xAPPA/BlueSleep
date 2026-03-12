import Foundation

enum ProtectionMode: Int, CaseIterable {
    case disableBluetooth = 0
    case blockNew = 1
    case disconnectAll = 2

    var title: String {
        switch self {
        case .disableBluetooth: return "Disable Bluetooth"
        case .blockNew: return "Block New Connections"
        case .disconnectAll: return "Disconnect All Devices"
        }
    }

    var description: String {
        switch self {
        case .disableBluetooth: return "Turns off Bluetooth completely (requires admin)"
        case .blockNew: return "Disables discoverability"
        case .disconnectAll: return "Disconnects paired devices"
        }
    }
}
