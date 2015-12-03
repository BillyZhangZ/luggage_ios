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
@interface ViewController ()<MFMessageComposeViewControllerDelegate, LuggageDelegate>
{
    LuggageDevice *_luggageDevice;
    BOOL _enableLostMode;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _luggageDevice = [[LuggageDevice alloc]init:self];
    _enableLostMode = false;
    // Do any additional setup after loading the view from its nib.
    [self.navigatorBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_enableLostMode) {
        [self.lostButton setTitle:@"关闭防丢模式" forState:UIControlStateNormal];
    }
    else
    {
        [self.lostButton setTitle:@"开启防丢模式" forState:UIControlStateNormal];
    }
   // say(@"welcome");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onMenuButton:(id)sender {
    AppDelegate *app =[[UIApplication sharedApplication]delegate];
    [app showMenu];
}
- (IBAction)onShareButton:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app sendTextContent:@"Luggage, 让旅行更放心" withScene:WXSceneSession];
}
- (IBAction)onRemoteUnlock:(id)sender {
    NSArray *recipientList = [[NSArray alloc]initWithObjects:@"+8613817219941", nil];
    [self sendSMS:@"KS" recipientList:recipientList];
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
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

#pragma luggage device delegate
-(void)onLuggageDeviceConected
{
#if 0
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"luggage已连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

-(void)onLuggageDeviceDissconnected
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"luggage已断开连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)onLuggageNtfChar:(NSString *)recData
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到数据" message:recData preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
