//
//  MainViewController.m
//  luggage
//
//  Created by 张志阳 on 11/29/15.
//  Copyright © 2015 张志阳. All rights reserved.
//
#import "AppDelegate.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ViewController.h"
#import "LocateViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "BLEDevice.h"
#import "BLEViewController.h"

@interface ViewController ()<MFMessageComposeViewControllerDelegate, LuggageDelegate>
{
    LuggageDevice *_luggageDevice;
    CBPeripheral *_foundDev;
    BOOL _enableLostMode;
    
    ZZYAcount *_account;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // _luggageDevice = [[LuggageDevice alloc]init:self];
    _enableLostMode = false;
    // Do any additional setup after loading the view from its nib.
    [self.navigatorBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    _account = app.account;
    
   }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (_account.remotePhoneNumber != nil) {
       // [self.addDeviceButton setEnabled:NO];
        _luggageDevice = [[LuggageDevice alloc]init:self];
    }

    if (_enableLostMode) {
        [self.lostButton setTitle:@"关闭防丢模式" forState:UIControlStateNormal];
    }
    else
    {
        [self.lostButton setTitle:@"开启防丢模式" forState:UIControlStateNormal];
    }
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
    [_locateButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_locateButton.layer setCornerRadius:10];
    [_locateButton.layer setBorderWidth:2];//设置边界的宽度
    
    [_lostButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_lostButton.layer setCornerRadius:10];
    [_lostButton.layer setBorderWidth:2];//设置边界的宽度
    
    [_bleUnlockButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_bleUnlockButton.layer setCornerRadius:10];
    [_bleUnlockButton.layer setBorderWidth:2];//设置边界的宽度
    
    [_smsUnlockButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_smsUnlockButton.layer setCornerRadius:10];
    [_smsUnlockButton.layer setBorderWidth:2];//设置边界的宽度
    
    [_weightLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_weightLabel.layer setCornerRadius:10];
    [_weightLabel.layer setBorderWidth:2];//设置边界的宽度
    

    // [_locateButton.layer setBorderColor:color];
    //[_lostButton.layer setBorderColor:color];
    //[_locateButton.layer setBorderColor:color];
    //[_locateButton.layer setBorderColor:color];

   // say(@"welcome");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    //fix me
    [super viewWillDisappear:animated];
    [_luggageDevice BLEDisconnect];
    _luggageDevice = nil;
}
- (IBAction)onMenuButton:(id)sender {
    AppDelegate *app =[[UIApplication sharedApplication]delegate];
    [app showMenu];
}

- (IBAction)onAddDeviceButton:(id)sender {
    //AppDelegate *app = [[UIApplication sharedApplication] delegate];
    //[app sendTextContent:@"Luggage, 让旅行更放心" withScene:WXSceneSession];
    BLEViewController *vc = [[BLEViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)onRemoteUnlock:(id)sender {
    if (_account.remotePhoneNumber == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未绑定设备" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSArray *recipientList = [[NSArray alloc]initWithObjects:_account.remotePhoneNumber, nil];
    [self sendSMS:@"KS" recipientList:recipientList];
}
- (IBAction)onBLEUnlock:(id)sender {
    [self bleSendUnlock];
}
- (IBAction)onRegisterFinger:(id)sender {
    [self bleSendRegisterFinger];
}
- (IBAction)onDeleteFinger:(id)sender {
    [self bleSendDeleteFinger];
}

- (IBAction)onLocateButton:(id)sender {
    LocateViewController *vc = [[LocateViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onLostButton:(id)sender {
    if (_enableLostMode) {
        _enableLostMode = false;
        [(UIButton *)sender setTitle:@"开启防丢模式" forState:UIControlStateNormal];
    }
    else
    {
        _enableLostMode = true;
        [(UIButton *)sender setTitle:@"关闭防丢模式" forState:UIControlStateNormal];
    }
}

#pragma sms delegate
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
        
    {
        
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:NO completion:nil];
        
    }
    
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:NO completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"ViewController: Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"ViewController: Message sent");
    else
        NSLog(@"ViewController: Message failed");
}

#pragma luggage device delegate
-(void)onDeviceDiscovered:(CBPeripheral *)device rssi:(NSInteger)rssi;
{
    NSLog(@"ViewController: discovered\n");
    if ([device.name isEqualToString:@"MTKBTDEVICE"]) {
        _foundDev = device;
        [self performSelector:@selector(connectToDevice) withObject:self afterDelay:1];
        NSLog(@"ViewController: %@", device.name);

    }
}
-(void)connectToDevice
{
    [_luggageDevice BLEConectTo:_foundDev];

}
-(void)onLuggageDeviceConected
{
    NSLog(@"ViewController: connected\n");
    
}

-(void)onNtfCharateristicFound
{
    NSLog(@"ViewController: ntf character found\n");
}

-(void)onWriteCharateristicFound
{
    NSLog(@"ViewController: write character found\n");
}

-(void)onLuggageNtfChar:(NSString *)recData
{
    NSLog(@"ViewController: receive %@", recData);
#if 0
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"linkit:"];
    [log appendString:recData];
    self.logText.text  = log;
    
    switch (_opration) {
        case BLE_OPERATION_NONE:
            //error
            break;
        case BLE_OPERATION_GET_LUGGAGE_NUMBER:
            app.account.remotePhoneNumber = getATContent(recData);
            // [app.account setValue:getATContent(recData) forKey:@"remotePhoneNumber"];
            NSLog(@"%@",app.account.remotePhoneNumber);
            //  [self sendLocalPhoneNumber];
            // _opration = BLE_OPERATION_SEND_LOCAL_PHONE_NUMBER;
            break;
        case BLE_OPERATION_SEND_LOCAL_PHONE_NUMBER:
            
            _opration = BLE_OPERATION_NONE;
            break;
        default:
            break;
    }
    _opration = BLE_OPERATION_NONE;
#endif
}

#pragma BLE FUNCTION CALL
-(void)bleSendUnlock
{
    NSLog(@"ViewController: send character\n");
    [_luggageDevice LuggageWriteChar:@"AT+LOCKOFF\r"];
}

-(void)bleSendRegisterFinger
{
    NSLog(@"ViewController: send character\n");
    [_luggageDevice LuggageWriteChar:@"AT+FINGERREG\r"];
}

-(void)bleSendDeleteFinger
{
    NSLog(@"ViewController: send character\n");
    [_luggageDevice LuggageWriteChar:@"AT+FINGERDEL\r"];
}

-(void)bleSendLock
{
    NSLog(@"ViewController: send character\n");
    [_luggageDevice LuggageWriteChar:@"AT+LOCKON\r"];
}




//distance = pow(10, (rssi-49)/10*4.0)
-(void)onSubscribeDone
{
    //[self performSelector:@selector(sendChar) withObject:self afterDelay:1];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备已连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)onLuggageDeviceDissconnected
{
    NSLog(@"ViewController: disconnected\n");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备已断开连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    

}

@end