//
//  HeartRateDevice.m
//  BTLE Transfer
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
    CBCentralManager      *_heartRateManager;
    CBPeripheral          *_heartRateDevice;
    NSTimer               *_timer;
    id                    _heartRateDelegate;
    CBCharacteristic *_writeChar;
}
@end

@implementation LuggageDevice

-(instancetype)init:(id)delegate
{
    self = [super init];
    if (self) {
        _heartRateDelegate = delegate;
        _heartRateManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _writeChar = nil;
        if (_heartRateDelegate == nil || _heartRateManager == nil) {
            NSLog(@"Exception in heart rate lib, delegate or manager is nil");
        }
    }
    else
    {
        NSLog(@"Exception in heart rate lib, super init failed");
    }
    return self;
}


-(void)LuggageWriteChar:(NSString *)txData
{
    if (_writeChar) {
        [_heartRateDevice writeValue:[txData dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_writeChar type:CBCharacteristicWriteWithResponse];
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
            NSLog(@"HeartLib: CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"HeartLib: CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"HeartLib: CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"HeartLib: CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"HeartLib: CBCentralManagerStatePoweredOff");
            //maybe ble is closed in process
            //[self stopTimer];
            [_heartRateDelegate onLuggageDeviceDissconnected];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"HeartLib: CBCentralManagerStatePoweredOn");
            break;

        default:
            NSLog(@"HeartLib: default");
            break;
    }
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
       
       // [_heartRateDelegate isheartRateAvailable:NO];
        //assume ble is not openned, when openned, this function will enter again
        
        return;
    }
    //
    NSLog(@"trying to find devices");
#ifdef GET_DEVICE_FROM_SYSTEM
    NSArray *heartRateDevices = [_heartRateManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:LUGGAGE_SERVICE_UUID]]];
    if([heartRateDevices count] != 0)
    {
        _heartRateDevice = (CBPeripheral *)[heartRateDevices objectAtIndex:0];
        [_heartRateManager connectPeripheral:_heartRateDevice options:nil];
        [self stopTimer];
        NSLog(@"HeartLib: find connected heartrate devices: %@", [_heartRateDevice name]);
    }
    else
    {
        //no connected devices
       // [_heartRateDelegate isheartRateAvailable:NO];
        [self startTimer];
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
    [_heartRateManager stopScan];
    [_heartRateManager connectPeripheral:peripheral options:nil];
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"%@ %d", peripheral.name, [RSSI integerValue]);
    
    [_heartRateDelegate onDeviceDiscovered:peripheral rssi:[RSSI integerValue]];
    //[central stopScan];
    
}
-(void)startTimer
{
    if (_heartRateManager.state == CBCentralManagerStatePoweredOff) {
        //wait till BLE is open
        [self stopTimer];
        return;
    }
    if (_timer == nil) _timer =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

}

-(void)stopTimer
{
    if (_timer !=nil) {
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)onTimer
{
    NSLog(@"HeartRateDevice: Re-find connected devices");
    NSArray *heartRateDevices = [_heartRateManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:LUGGAGE_SERVICE_UUID]]];
    if([heartRateDevices count] != 0)
    {
        _heartRateDevice = (CBPeripheral *)[heartRateDevices objectAtIndex:0];
        [_heartRateManager connectPeripheral:_heartRateDevice options:nil];
        [self stopTimer];
        NSLog(@"HeartLib: find connected heartrate devices: %@", [_heartRateDevice name]);
    }
}

/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"HeartLib: Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self startTimer];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"HeartLib: Peripheral Connected");
    //inform delegate and remove timer
    [_heartRateDelegate onLuggageDeviceConected];
    _heartRateDevice = peripheral;
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
        NSLog(@"HeartLib: Error discovering services: %@", [error localizedDescription]);
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
        NSLog(@"HeartLib: Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:LUGGAGE_WRITE_CHARACTERISTIC_UUID]]) {
                _writeChar = characteristic;
                [_heartRateDelegate onWriteCharateristicFound];
            }
        
            // And check if it's the right one
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:LUGGAGE_NTF_CHARACTERISTIC_UUID]]) {
                [_heartRateDelegate onNtfCharateristicFound];
                // If it is, subscribe to it
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
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
    unsigned short heartRate = 0;
    if (error) {
        NSLog(@"HeartLib: Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        
        // Cancel our subscription to the characteristic
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // and disconnect from the peripehral
        [_heartRateManager cancelPeripheralConnection:peripheral];
    }
    
    //heartRate = *((Byte *)characteristic.value.bytes+1);
    [_heartRateDelegate onLuggageNtfChar:stringFromData];

    // Log it
    NSLog(@"HeartLib: Heart Rate: %@", stringFromData);
}


/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"HeartLib: Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:LUGGAGE_NTF_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"HeartLib: Notification began on %@", characteristic);
        [_heartRateDelegate onSubscribeDone];
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
      //  NSLog(@"HeartLib: Notification stopped on %@.  Disconnecting", characteristic);
        //[_heartRateManager cancelPeripheralConnection:peripheral];
        //[_heartRateDelegate onSubscribeDone];

    }
}


/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"HeartLib: Peripheral Disconnected");
    [_heartRateDelegate onLuggageDeviceDissconnected];
    //[self startTimer];
}


/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (_heartRateDevice.state == CBPeripheralStateDisconnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (_heartRateDevice.services != nil) {
        for (CBService *service in _heartRateDevice.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:LUGGAGE_NTF_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [_heartRateDevice setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [_heartRateManager cancelPeripheralConnection:_heartRateDevice];
}

@end