# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

BlueSleep — macOS menu bar app that applies Bluetooth protection when the system sleeps. Swift 5, SwiftUI + AppKit, macOS 13.0+. No external dependencies.

## Build

```bash
xcodebuild build -scheme BlueSleep -configuration Debug
xcodebuild build -scheme BlueSleep -configuration Release
```

No test target, no linter, no package manager.

## Architecture

MVVM with services. ~290 lines total.

- **BlueSleepApp** → SwiftUI entry, delegates to AppDelegate
- **AppDelegate** → NSStatusBar menu bar icon + popover lifecycle
- **MenuBarView** → SwiftUI popover UI (toggle, mode picker, settings link)
- **MenuBarViewModel** → orchestrates BluetoothService + SleepWakeMonitor, manages AppSettings and login item via ServiceManagement
- **BluetoothService** → controls Bluetooth state via private IOBluetooth C APIs (bridging header)
- **SleepWakeMonitor** → listens to NSWorkspace sleep/wake notifications, fires callbacks
- **AppSettings** → @AppStorage-backed persistence (isEnabled, protectionMode)
- **ProtectionMode** → enum: disableBluetooth, blockNew, disconnectAll

**Flow**: sleep detected → SleepWakeMonitor callback → MenuBarViewModel → BluetoothService applies protection → wake detected → BluetoothService restores state.

## Key Details

- `LSUIElement: true` in Info.plist — runs as background agent (no dock icon)
- Bridging header (`BlueSleep-Bridging-Header.h`) exposes private `IOBluetoothPreference{Get,Set}ControllerPowerState` and `DiscoverableState` C functions
- Bluetooth entitlement required (`com.apple.security.device.bluetooth`)
