//
//  LuggageDevice.m
//
//  Created by 张志阳 on 15/5/13.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEService.h"
#import "BLEDevice.h"
typedef enum{
    BLE_INITED = 0,
    BLE_CONNECTED,
}BLEState;

@interface LuggageDevice ()<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager      *_luggageManager;
    CBPeripheral          *_luggageDevice;
    id                    _luggageDelegate;
    CBCharacteristic *_writeChar;
}
@end

@implementation LuggageDevice

-(instancetype)init:(id)delegate
{
    self = [super init];
    if (self) {
        _luggageDelegate = delegate;
        _luggageManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _writeChar = nil;
        if (_luggageDelegate == nil || _luggageManager == nil) {
            NSLog(@"Exception in BLE lib, delegate or manager is nil");
        }
    }
    else
    {
        NSLog(@"Exception in ble lib, super init failed");
    }
    return self;
}


-(void)LuggageWriteChar:(NSString *)txData
{
    if (_writeChar) {
        [_luggageDevice writeValue:[txData dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_writeChar type:CBCharacteristicWriteWithResponse];
    }
    NSLog(@"write character");
}
/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"BLELib: CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"BLELib: CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"BLELib: CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"BLELib: CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"BLELib: CBCentralManagerStatePoweredOff");
            //maybe ble is closed in process
            //[self stopTimer];
            [_luggageDelegate onLuggageDevicePowerOff];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"BLELib: CBCentralManagerStatePoweredOn");
            [_luggageDelegate onLuggageDevicePowerOn];
            break;

        default:
            NSLog(@"BLELib: default");
            break;
    }
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
       
       // [_luggageDelegate isheartRateAvailable:NO];
        //assume ble is not openned, when openned, this function will enter again
        
        return;
    }
    //
    NSLog(@"trying to find devices");
#if 1
    NSArray *heartRateDevices = [_luggageManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:LUGGAGE_SERVICE_UUID]]];
    if([heartRateDevices count] != 0)
    {
        _luggageDevice = (CBPeripheral *)[heartRateDevices objectAtIndex:0];
        [_luggageManager connectPeripheral:_luggageDevice options:nil];
        NSLog(@"HeartLib: find connected heartrate devices: %@", [_luggageDevice name]);
    }
    else
    {
        [central scanForPeripheralsWithServices:nil
                                        options:nil];
    }
#else
    [central scanForPeripheralsWithServices:nil
                                               options:nil];
    //[central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEE0"]]
    //                                options:nil];

#endif
}

-(void)BLEConectTo:(CBPeripheral *)peripheral
{
    [_luggageManager stopScan];
    [_luggageManager connectPeripheral:peripheral options:nil];
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"%@ %d", peripheral.name, [RSSI integerValue]);
    
    [_luggageDelegate onDeviceDiscovered:peripheral rssi:[RSSI integerValue]];
    //[central stopScan];
    
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"BLELib: Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"BLELib: Peripheral Connected");
    //inform delegate and remove timer
    [_luggageDelegate onLuggageDeviceConected];
    _luggageDevice = peripheral;
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:LUGGAGE_SERVICE_UUID]]];
}


/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"BLELib: Error discovering services: %@", [error localizedDescription]);
        return;
    }
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:LUGGAGE_NTF_CHARACTERISTIC_UUID]] forService:service];
        [peripheral discoverCharacteristics:nil forService:service];

    }
}

/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"BLELib: Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:LUGGAGE_WRITE_CHARACTERISTIC_UUID]]) {
                _writeChar = characteristic;
                [_luggageDelegate onWriteCharateristicFound];
                NSLog(@"found write char");
            }
        
            // And check if it's the right one
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:LUGGAGE_NTF_CHARACTERISTIC_UUID]]) {
                [_luggageDelegate onNtfCharateristicFound];
                // If it is, subscribe to it
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                NSLog(@"set config desc");
            }
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"log");
}
/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"BLELib: Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        
        // Cancel our subscription to the characteristic
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // and disconnect from the peripehral
        [_luggageManager cancelPeripheralConnection:peripheral];
    }
    
    //heartRate = *((Byte *)characteristic.value.bytes+1);
    [_luggageDelegate onLuggageNtfChar:stringFromData];

    // Log it
    NSLog(@"BLELib: Rec data: %@", stringFromData);
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error NS_AVAILABLE(NA, 8_0);
{
    [_luggageDelegate onRssiRead:RSSI];
}
/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"BLELib: Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:LUGGAGE_NTF_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"BLELib: Notification began on %@", characteristic);
        [_luggageDelegate onSubscribeDone];
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"HeartLib: Notification stopped on %@.  Disconnecting", characteristic);
        //[_heartRateManager cancelPeripheralConnection:peripheral];
        //[_luggageDelegate onSubscribeDone];

    }
}


/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"BLELib: Peripheral Disconnected");
    [_luggageDelegate onLuggageDeviceDissconnected];
    //[self startTimer];
}

-(void)BLEDisconnect
{
    [self cleanup];
}

/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (_luggageDevice.state == CBPeripheralStateDisconnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (_luggageDevice.services != nil) {
        for (CBService *service in _luggageDevice.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:LUGGAGE_NTF_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [_luggageDevice setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [_luggageManager cancelPeripheralConnection:_luggageDevice];
}

@end