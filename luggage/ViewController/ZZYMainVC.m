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
    _enableLostMode = false;
    // Do any additional setup after loading the view from its nib.
    [self.navigatorBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];
    
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
        _lostButton.titleLabel.numberOfLines = 0;
        _lostButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_lostButton setTitle:distanceStr forState:UIControlStateNormal];

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
- (IBAction)onTestButton:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication]delegate];

    [app pushLocalNotification];
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