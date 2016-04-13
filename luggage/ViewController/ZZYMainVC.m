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
#import "BatteryView.h"

@interface ZZYMainVC ()<MFMessageComposeViewControllerDelegate>
{
    BOOL _enableLostMode;
    float _distance;
    int _rssiCount;
    ZZYAcount *_account;
    BatteryView *_batView;
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
    bgView.image = [UIImage imageNamed:@"login_bg.jpg"];
    //[self.view addSubview: bgView];
    //[self.view sendSubviewToBack:bgView];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
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
    
    
    rc.origin.y = self.locateButton.frame.origin.y;
    rc.origin.x = self.locateButton.frame.origin.x;
    rc.size.width = self.locateButton.frame.size.width;
    rc.size.height = self.locateButton.frame.size.height;
    [self.locateButton setFrame:rc];
    
    rc.origin.y = self.weightButton.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - self.weightButton.frame.size.width/2;
    rc.size.width =  self.weightButton.frame.size.width;
    rc.size.height = self.weightButton.frame.size.height;
    [self.weightButton setFrame:rc];
    
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
    
   // CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
    [_locateButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_locateButton.layer setCornerRadius:10];
    [_locateButton.layer setBorderWidth:2];//设置边界的宽度
    
    [_bleUnlockButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_bleUnlockButton.layer setCornerRadius:10];
    [_bleUnlockButton.layer setBorderWidth:2];//设置边界的宽度
    
    [_smsUnlockButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_smsUnlockButton.layer setCornerRadius:10];
    [_smsUnlockButton.layer setBorderWidth:2];//设置边界的宽度
    
    [_weightButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_weightButton.layer setCornerRadius:10];
    [_weightButton.layer setBorderWidth:2];//设置边界的宽度
    
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
        //check if alert according to setting
        if (![app.setting.alertSetting boolValue]) {
            return;
        }
        NSString * distance = [change valueForKey:NSKeyValueChangeNewKey];
        if ([distance floatValue] > 6) {
          [app pushLocalNotification];
        }
#if 0
        NSString *distanceStr = [NSString stringWithFormat:@"dis:%@", distance];//_distance/_rssiCount];
        _alertButton.titleLabel.numberOfLines = 0;
        _alertButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_alertButton setTitle:distanceStr forState:UIControlStateNormal];
#endif
        NSLog(@"distance is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    }
    else if([keyPath isEqualToString:@"battery"])
    {
        NSString *battery = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"battery is changed! new=%@", battery);
        
        if ([battery integerValue] != _batView.batttery) {
            [_batView setBatttery:[battery integerValue]];
        }
    }
    else if([keyPath isEqualToString:@"weight"])
    {
        NSString *weight = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"weight is changed! new=%@", weight);
        [_weightButton setTitle:[NSString stringWithFormat:@"Weight：%@Kg", weight]  forState:UIControlStateNormal];
    }
    else if([keyPath isEqualToString:@"FINGERREG"])
    {
        NSString *ret = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"add finger is changed! new=%@", ret);
        NSString *title = [NSString stringWithFormat:@"Add fingerprint %@",[ret integerValue] != -1?@"OK":@"Failed"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([keyPath isEqualToString:@"FINGERDEL"])
    {
        NSString *ret = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"del finger is changed! new=%@", ret);
        NSString *title = [NSString stringWithFormat:@"Delete fingerprint %@",[ret integerValue] != -1?@"OK":@"Failed"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (IBAction)onAddDeviceButton:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if (app.isDeviceBonded) {        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Device Bonded" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    //[app sendTextContent:@"Luggage, 让旅行更放心" withScene:WXSceneSession];
    ZZYAddDeviceVC *vc = [[ZZYAddDeviceVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)onRemoteUnlock:(id)sender {
    if (_account.remotePhoneNumber == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Bond Device" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
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
    //[self bleSendRegisterFinger];
}
- (IBAction)onDeleteFinger:(id)sender {
    //[self bleSendDeleteFinger];
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