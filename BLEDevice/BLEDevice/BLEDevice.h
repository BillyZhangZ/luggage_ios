//
//  HeartRateDevice.h
//  BTLE Transfer
//
//  Created by 张志阳 on 15/5/13.
//  Copyright (c) 2015年 Apple. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>

@protocol LuggageDelegate

@required
-(void)onLuggageNtfChar:(NSString *) recData;
-(void)onLuggageDeviceDissconnected;
-(void)onLuggageDeviceConected;
-(void)onDeviceDiscovered:(CBPeripheral *)device rssi:(NSInteger)rssi;
-(void)onNtfCharateristicFound;
-(void)onWriteCharateristicFound;
-(void)onSubscribeDone;
@end


@interface LuggageDevice:NSObject
/**
 *Called after init to start scan/connect heart rate device,
 *delegate should be responsible for implementing HeartRateDelegate protocol
 *whenever heart rate is updated, tdidUpdateHeartRate will be exected
 **/
-(instancetype)init:(id)delegate;
-(void)LuggageWriteChar:(NSString *)txData;
-(void)BLEConectTo:(CBPeripheral *)peripheral;
-(void)BLEDisconnect;
@end

