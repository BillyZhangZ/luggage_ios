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
#import "ZZYMainVC.h"
#import "ZZYLocateVC.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "BLEDevice.h"
#import "ZZYAddDeviceVC.h"

@interface ZZYMainVC ()<MFMessageComposeViewControllerDelegate, LuggageDelegate>
{
    LuggageDevice *_luggageDevice;
    CBPeripheral *_foundDev;
    BOOL _enableLostMode;
    float _distance;
    int _rssiCount;
    NSTimer *_updateRssiTimer;
    ZZYAcount *_account;
}
@end

@implementation ZZYMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
   // _luggageDevice = [[LuggageDevice alloc]init:self];
    _distance = 0;
    _rssiCount = 0;
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

  /*  if (_enableLostMode) {
        [self.lostButton setTitle:@"关闭防丢模式" forState:UIControlStateNormal];
    }
    else
    {
        [self.lostButton setTitle:@"开启防丢模式" forState:UIControlStateNormal];
    }*/
    
   // CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
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
    
    [_weightButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_weightButton.layer setCornerRadius:10];
    [_weightButton.layer setBorderWidth:2];//设置边界的宽度
    
    [_battButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_battButton.layer setCornerRadius:10];
    [_battButton.layer setBorderWidth:2];//设置边界的宽度

    [_regFingerButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_regFingerButton.layer setCornerRadius:10];
    [_regFingerButton.layer setBorderWidth:2];//设置边界的宽度

    [_delFingerButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_delFingerButton.layer setCornerRadius:10];
    [_delFingerButton.layer setBorderWidth:2];//设置边界的宽度

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
    ZZYAddDeviceVC *vc = [[ZZYAddDeviceVC alloc]init];
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
- (IBAction)onTestButton:(id)sender {
    [self pushLocalNotification];
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
- (IBAction)onWeightButton:(id)sender {
    [self bleSendGetWeight];
}
- (IBAction)onBattButton:(id)sender {
    [_luggageDevice LuggageWriteChar:@"AT+GTBAT\r"];
}

- (IBAction)onLocateButton:(id)sender {
    ZZYLocateVC *vc = [[ZZYLocateVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onLostButton:(id)sender {
   /* if (_enableLostMode) {
        _enableLostMode = false;
        [(UIButton *)sender setTitle:@"开启防丢模式" forState:UIControlStateNormal];
    }
    else
    {
        _enableLostMode = true;
        [(UIButton *)sender setTitle:@"关闭防丢模式" forState:UIControlStateNormal];
    }*/
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
    if ([device.name isEqualToString:@"SmartLuggage"]) {
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
    _updateRssiTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onUpdateRssi) userInfo:nil repeats:YES];

}

-(void)onUpdateRssi
{
    [_foundDev readRSSI];
}

-(void)onRssiRead:(NSNumber*)rssi
{
    NSLog(@"%@\n", rssi);
    
    float distance = powf(10, (-63-[rssi floatValue])/10.0/4.0);
    _distance += distance;
    _rssiCount++;
    if (distance > 5) {
        [self pushLocalNotification];
    }
    NSString *distanceStr = [NSString stringWithFormat:@"rssi:%@ \ndis:%.2f",rssi, distance];//_distance/_rssiCount];
    _lostButton.titleLabel.numberOfLines = 0;
    _lostButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_lostButton setTitle:distanceStr forState:UIControlStateNormal];
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
    if ([getATCmd(recData) isEqualToString:@"AT+WT"]) {
        
        [_weightButton setTitle:[NSString stringWithFormat:@"重量：%@千克", getATContent(recData)]  forState:UIControlStateNormal];
    }
    if ([getATCmd(recData) isEqualToString:@"AT+BAT"]) {
        [_battButton setTitle:[NSString stringWithFormat:@"电量：%@%%", getATContent(recData)]  forState:UIControlStateNormal];
    }
    
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

-(void)bleSendGetWeight
{
    NSLog(@"ViewController: send character\n");
    [_luggageDevice LuggageWriteChar:@"AT+GTWT\r"];
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
    [_updateRssiTimer invalidate];
    _updateRssiTimer = nil;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备已断开连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    

}

-(NSString *) stringFromDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        
        // zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
        // [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

-(NSDate *) getDateFromString:(NSString *)string
{
    static NSDateFormatter *dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    
    NSDate *tm = [dateFormatter dateFromString:string];
    return tm;
}

-(void)pushLocalNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置1秒之后
    NSDate *pushDate = [NSDate date];
    
    NSString *destDateString = [self stringFromDate:pushDate];
    
    NSDate *pushDate1 =[self getDateFromString:destDateString];
    
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate1;
        // 设置时区
        notification.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        // 设置重复间隔
        notification.repeatInterval = 0;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = @"请留意您的luggage";
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];   
        
    }
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

-(void)cancleLocalNotification
{
    // 获得 UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    //声明本地通知对象
    UILocalNotification *localNotification;
    if (localArray) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key"];
                if ([inKey isEqualToString:@"对应的key值"]) {
                    if (localNotification){
                        localNotification = nil;
                    }
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (!localNotification) {
            //不存在初始化
            localNotification = [[UILocalNotification alloc] init];
        }
        
        if (localNotification) {
            //不推送 取消推送
            [app cancelLocalNotification:localNotification];
            return;
        }  
    }
}

#pragma mark - disable landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end