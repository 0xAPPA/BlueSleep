import Foundation
import IOBluetooth

final class BluetoothService {
    static let shared = BluetoothService()

    private var wasDiscoverable: Bool = true
    private var connectedDevices: [IOBluetoothDevice] = []

    private init() {}

    func applyProtection(mode: ProtectionMode) {
        saveCurrentState()

        switch mode {
        case .disableBluetooth:
            setPowerState(enabled: false)
        case .blockNew:
            setDiscoverable(enabled: false)
        case .disconnectAll:
            disconnectAllDevices()
        }
    }

    func restoreState(mode: ProtectionMode, autoReconnect: Bool) {
        switch mode {
        case .disableBluetooth:
            setPowerState(enabled: true)
        case .blockNew:
            if wasDiscoverable {
                setDiscoverable(enabled: true)
            }
        case .disconnectAll:
            if autoReconnect {
                reconnectDevices()
            }
        }
    }

    // MARK: - Private

    private func saveCurrentState() {
        wasDiscoverable = IOBluetoothPreferenceGetDiscoverableState() == 1

        if let paired = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] {
            connectedDevices = paired.filter { $0.isConnected() }
        }
    }

    private func setPowerState(enabled: Bool) {
        IOBluetoothPreferenceSetControllerPowerState(enabled ? 1 : 0)
    }

    private func setDiscoverable(enabled: Bool) {
        IOBluetoothPreferenceSetDiscoverableState(enabled ? 1 : 0)
    }

    private func disconnectAllDevices() {
        guard let paired = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else { return }

        for device in paired where device.isConnected() {
            device.closeConnection()
        }
    }

    private func reconnectDevices() {
        for device in connectedDevices {
            device.openConnection()
        }
    }
}
