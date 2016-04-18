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
#import "ZZYAddDeviceVC.h"
#import "BatteryView.h"
#import "UAProgressView.h"
#import <AVFoundation/AVFoundation.h>

//standard weight
#define STANDARD_WEIGHT 20.0

@interface ZZYMainVC ()<UIGestureRecognizerDelegate, UIAccelerometerDelegate>
{
    float _distance;
    int _rssiCount;
    ZZYAcount *_account;
    BatteryView *_batView;
    UAProgressView *_weightView;
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
    
    int statusBarHeight = 20;
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rcScreen.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:70/255.0 alpha:1.0];
    [self.view addSubview:statusBarView];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigatorBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigatorBar.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:70/255.0 alpha:1.0];
    
    //make it center
    rc.size.width = 150;
    rc.size.height = 150;
    rc.origin.y = self.bleUnlockButton.frame.origin.y;
    rc.origin.x = (rcScreen.size.width - rc.size.width)/2;
    [self.bleUnlockButton setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
    self.bleUnlockButton.tintColor = [UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0];
    [self.bleUnlockButton setFrame:rc];
    
    
    rc.origin.y += rc.size.height + 20;
    rc.size.height = rc.size.width = 150;
    rc.origin.x = (rcScreen.size.width - rc.size.width)/2;
    _weightView = [[UAProgressView alloc]initWithFrame:rc];
    [self.view addSubview:_weightView];
    [self setupWeightView];

    
    rc.origin.x = rcScreen.size.width - 55;
    rc.origin.y = 90;
    rc.size.height = 15;
    rc.size.width = 40;
    _batView = [[BatteryView alloc]initWithFrame:rc];
    [self.view addSubview:_batView];
    
    rc.origin.y = 80;
    rc.origin.x = rcScreen.size.width - 100;
    rc.size.width = 30;
    rc.size.height = 30;
    [self.locateButton setImage:[UIImage imageNamed:@"Location2"] forState:UIControlStateNormal];
    self.locateButton.tintColor = [UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0];
    self.locateButton.layer.cornerRadius = 2;

    [self.locateButton setFrame:rc];
    
    
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
    
    UIScreenEdgePanGestureRecognizer * screenEdgePan
    = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    screenEdgePan.delegate = self;
    screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.bleUnlockButton.layer.cornerRadius = self.bleUnlockButton.frame.size.width/2;
    self.bleUnlockButton.layer.borderWidth = 1;
    self.bleUnlockButton.layer.borderColor = [UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0].CGColor;
    [self resignFirstResponder];
    [super viewWillAppear:YES];
    // say(@"welcome");
}

-(void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
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

- (void)setupWeightView {
    __weak ZZYMainVC *weakSelf = self;
    
    _weightView.tintColor = [UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.0, 100.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.numberOfLines = 2;
    label.textColor = [UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0];//[UIColor colorWithRed:5/255.0 green:39/255.0 blue:175/255.0 alpha:1.0];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
    label.text = @"Weight";
    _weightView.centralView = label;

    [_weightView setAnimationDuration:1.0];
    [_weightView setLineWidth:5];
    _weightView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
        [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%\n%.2fKg", progress * 100,progress*STANDARD_WEIGHT]];
    };

    _weightView.didSelectBlock = ^(UAProgressView *progressView) {
        [weakSelf bleSendGetWeight];
        //AppDelegate* app = [[UIApplication sharedApplication]delegate];
        //[app setValue:[NSString stringWithFormat:@"%f",31.0f] forKey:@"weight"];
        //[app testServerNotification];
    };
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
        NSLog(@"distance is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    }
    else if([keyPath isEqualToString:@"battery"])
    {
        NSString *battery = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"battery is changed! new=%@", battery);
        
     //   if ([battery integerValue] != _batView.batttery) {
            [_batView setBatttery:[battery integerValue]];
       // }
    }
    else if([keyPath isEqualToString:@"weight"])
    {
        NSString *weight = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"weight is changed! new=%@", weight);
        [_weightView setProgress:[weight floatValue]/STANDARD_WEIGHT animated:YES];
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

- (IBAction)onBLEUnlock:(id)sender {
    [self bleSendUnlock];
}

- (IBAction)onLocateButton:(id)sender {
    ZZYLocateVC *vc = [[ZZYLocateVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
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

- (void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state)
    {
        
    }
    else
    {
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        [app showMenu];
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

#pragma -shake
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"shake");
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0f];
        CGRect rc = _weightView.frame;
        rc.origin.y += 50;
        [_weightView setFrame:rc];
        [UIView commitAnimations];
    }
}
@end