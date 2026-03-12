# BlueSleep

MacOS menu bar app that protects your Bluetooth connections when your Mac sleeps.

<img src="/screenshot.png" width="270" alt="BlueSleep UI">

## Why

Bluetooth headphones with limited connection slots are a common bottleneck in multi-device setups. When a MacBook stays connected after the lid closes, it occupies a slot and prevents other devices from streaming audio — even when the Mac is idle. macOS provides no built-in way to release Bluetooth connections on sleep. BlueSleep fills that gap.

## What it does

When your Mac goes to sleep, BlueSleep applies your chosen Bluetooth protection mode. On wake, it optionally restores the previous state.

**Protection modes:**
- **Disable Bluetooth** — turns off the Bluetooth radio entirely
- **Block New Connections** — keeps Bluetooth on but prevents new devices from connecting
- **Disconnect All Devices** — disconnects all paired devices without disabling Bluetooth

**Other options:**
- Auto-reconnect on Wake — restores Bluetooth state when your Mac wakes
- Launch at Login — runs automatically in the background

## Requirements

- macOS 13.0+
- Bluetooth entitlement (`com.apple.security.device.bluetooth`)

## Build

```bash
xcodebuild build -scheme BlueSleep -configuration Release
```

No external dependencies. No package manager.

## Architecture

MVVM with services (~290 lines total). `SleepWakeMonitor` listens for system sleep/wake notifications and triggers `BluetoothService`, which controls Bluetooth state via private `IOBluetoothPreference` C APIs exposed through a bridging header.
