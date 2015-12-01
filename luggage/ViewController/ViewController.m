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

@interface ViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigatorBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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

@end
