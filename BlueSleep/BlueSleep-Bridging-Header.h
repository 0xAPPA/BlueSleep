#import <IOBluetooth/IOBluetooth.h>

// IOBluetooth preference functions (not in Swift headers)
extern int IOBluetoothPreferenceGetControllerPowerState(void);
extern void IOBluetoothPreferenceSetControllerPowerState(int state);
extern int IOBluetoothPreferenceGetDiscoverableState(void);
extern void IOBluetoothPreferenceSetDiscoverableState(int state);
