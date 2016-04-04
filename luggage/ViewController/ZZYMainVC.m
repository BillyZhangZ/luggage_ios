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
#import "ZZYAddDeviceVC.h"

@interface ZZYMainVC ()<MFMessageComposeViewControllerDelegate>
{
    BOOL _enableLostMode;
    float _distance;
    int _rssiCount;
    ZZYAcount *_account;
}
@end

@implementation ZZYMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    CGRect rc = rcScreen;
    rc.origin.y += 64;
    rc.size.height -= 64;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:rc];
    bgView.image = [UIImage imageNamed:@"crazy.jpg"];
    [self.view addSubview: bgView];
    [self.view sendSubviewToBack:bgView];
    _enableLostMode = false;
    
    int statusBarHeight = 20;
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rcScreen.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:70/255.0 alpha:1.0];
    [self.view addSubview:statusBarView];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigatorBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigatorBar.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:70/255.0 alpha:1.0];
    //make it center
    rc.origin.y = self.smsUnlockButton.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - (self.bleUnlockButton.frame.origin.x - self.smsUnlockButton.frame.origin.x + self.bleUnlockButton.frame.size.width)/2;
    rc.size.width = self.smsUnlockButton.frame.size.width;
    rc.size.height = self.smsUnlockButton.frame.size.height;
    [self.smsUnlockButton setFrame:rc];
    rc.origin.y = self.bleUnlockButton.frame.origin.y;
    rc.origin.x = self.smsUnlockButton.frame.origin.x + self.smsUnlockButton.frame.size.width + 10;
    rc.size.width = self.bleUnlockButton.frame.size.width;
    rc.size.height = self.bleUnlockButton.frame.size.height;
    [self.bleUnlockButton setFrame:rc];
    
    rc.origin.y = self.alertButton.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - (self.locateButton.frame.origin.x - self.alertButton.frame.origin.x + self.locateButton.frame.size.width)/2;
    rc.size.width = self.alertButton.frame.size.width;
    rc.size.height = self.alertButton.frame.size.height;
    [self.alertButton setFrame:rc];
    
    rc.origin.y = self.locateButton.frame.origin.y;
    rc.origin.x = self.alertButton.frame.origin.x + self.alertButton.frame.size.width + 10;
    rc.size.width = self.locateButton.frame.size.width;
    rc.size.height = self.locateButton.frame.size.height;
    [self.locateButton setFrame:rc];
    
    rc.origin.y = self.weightButton.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - self.weightButton.frame.size.width/2;
    rc.size.width =  self.weightButton.frame.size.width;
    rc.size.height = self.weightButton.frame.size.height;
    [self.weightButton setFrame:rc];
    
    rc.origin.y = self.battButton.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - self.battButton.frame.size.width/2;
    rc.size.width =  self.battButton.frame.size.width;
    rc.size.height = self.battButton.frame.size.height;
    [self.battButton setFrame:rc];

    rc.origin.y = self.regFingerButton.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - (self.delFingerButton.frame.origin.x - self.regFingerButton.frame.origin.x + self.delFingerButton.frame.size.width)/2;
    rc.size.width = self.regFingerButton.frame.size.width;
    rc.size.height = self.regFingerButton.frame.size.height;
    [self.regFingerButton setFrame:rc];
    
    rc.origin.y = self.delFingerButton.frame.origin.y;
    rc.origin.x = self.regFingerButton.frame.origin.x + self.regFingerButton.frame.size.width + 30;
    rc.size.width = self.delFingerButton.frame.size.width;
    rc.size.height = self.delFingerButton.frame.size.height;
    [self.delFingerButton setFrame:rc];
    
    rc.origin.x = 0;
    rc.origin.y = 20;
    rc.size.height = 44;
    rc.size.width = rcScreen.size.width;
    [self.navigatorBar setFrame:rc];
    
    rc.origin.x = self.navigatorBar.frame.size.width - self.addDeviceButton.frame.size.width;
    rc.origin.y = self.addDeviceButton.frame.origin.y;
    rc.size.width = self.addDeviceButton.frame.size.width;
    rc.size.height = self.addDeviceButton.frame.size.height;
    [self.addDeviceButton setFrame:rc];
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    _account = app.account;
    [app addObserver:self forKeyPath:@"distance" options:NSKeyValueObservingOptionNew context:nil];
    [app addObserver:self forKeyPath:@"battery" options:NSKeyValueObservingOptionNew context:nil];
    [app addObserver:self forKeyPath:@"weight" options:NSKeyValueObservingOptionNew context:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
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
    
    [_alertButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_alertButton.layer setCornerRadius:10];
    [_alertButton.layer setBorderWidth:2];//设置边界的宽度
    
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
}
- (IBAction)onMenuButton:(id)sender {
    AppDelegate *app =[[UIApplication sharedApplication]delegate];
    [app showMenu];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppDelegate *app =[[UIApplication sharedApplication]delegate];

    if ([keyPath isEqualToString:@"distance"]) {
        NSString * distance = [change valueForKey:NSKeyValueChangeNewKey];
        if ([distance floatValue] > 3) {
          [app pushLocalNotification];
        }
        
        NSString *distanceStr = [NSString stringWithFormat:@"dis:%@", distance];//_distance/_rssiCount];
        _alertButton.titleLabel.numberOfLines = 0;
        _alertButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_alertButton setTitle:distanceStr forState:UIControlStateNormal];

        NSLog(@"distance is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
        
    }
    else if([keyPath isEqualToString:@"battery"])
    {
        NSString *battery = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"battery is changed! new=%@", battery);
        
         [_battButton setTitle:[NSString stringWithFormat:@"电量：%@%%", battery]  forState:UIControlStateNormal];
    }
    else if([keyPath isEqualToString:@"weight"])
    {
        NSString *weight = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"weight is changed! new=%@", weight);
        [_weightButton setTitle:[NSString stringWithFormat:@"重量：%@千克", weight]  forState:UIControlStateNormal];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+GTBAT\r"];
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


#pragma BLE FUNCTION CALL
-(void)bleSendUnlock
{
    NSLog(@"ViewController: send character\n");
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+LOCKOFF\r"];
}

-(void)bleSendRegisterFinger
{
    NSLog(@"ViewController: send character\n");
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+FINGERREG\r"];
}

-(void)bleSendDeleteFinger
{
    NSLog(@"ViewController: send character\n");
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+FINGERDEL\r"];
}

-(void)bleSendLock
{
    NSLog(@"ViewController: send character\n");
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+LOCKON\r"];
}

-(void)bleSendGetWeight
{
    NSLog(@"ViewController: send character\n");
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+GTWT\r"];
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