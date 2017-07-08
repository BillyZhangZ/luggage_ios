//
//  XJSMSLoginViewController.m
//  Pao123
//
//  Created by 张志阳 on 15/6/26.
//  Copyright (c) 2015年 XingJian Software. All rights reserved.
//

#import "ZZYSMSLoginVC.h"
//#import "ZZYSMSRegisterViewController.h"
#import "ZZYSMSLoginVerifyVC.h"
#import "config.h"
//#import "XJLoginVC.h"
#import "AppDelegate.h"
#import <SMS_SDK/SMS_SDK.h>
//#import "PrivateViewController.h"
@interface ZZYSMSLoginVC ()
{
}
@end

@implementation ZZYSMSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];
    UIScreenEdgePanGestureRecognizer * screenEdgePan
    = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    screenEdgePan.delegate = self;
    screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.phoneNumberText.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberText.keyboardAppearance = UIKeyboardAppearanceLight;
    self.phoneNumberText.text = @"请输入您的手机号码";
    self.phoneNumberText.textColor = [UIColor grayColor];
    [self.phoneNumberText.layer setBorderColor:[UIColor redColor].CGColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"login dealloc");
}

#pragma mark - disable landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - TextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textColor = [UIColor whiteColor];
    textField.tintColor = [UIColor grayColor];
    textField.text = @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self isMobileNumber:textField.text]) {
               [SMS_SDK getVerificationCodeBySMSWithPhone:textField.text
                                              zone:@"86"
                                            result:^(SMS_SDKError *error)
         {
             if (!error)
             {
                 ZZYSMSLoginVerifyVC *vc = [[ZZYSMSLoginVerifyVC alloc]init];
                 vc.phoneNumber = textField.text;
                 [self presentViewController:vc animated:NO completion:nil];
             }
             else
             {
                 NSLog(@"发送失败");
             }
             
         }];
    }else if([textField.text length] == 11){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"对不起" message:@"请确认您的手机格式" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumberText) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if (strLength == 11) {
            [self performSelector:@selector(delayResignResponsor) withObject:self afterDelay:0.3];
        }
    }
    return YES;
}

-(void)delayResignResponsor
{
    [self.phoneNumberText resignFirstResponder];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum{
    NSString * MOBILE = MOBILE_PHONE_NUMBER;
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - gesture response
-(void)tapHandle:(UITapGestureRecognizer *)tap
{
    [self.phoneNumberText resignFirstResponder];
}

- (IBAction)menuButtonClicked:(id)sender {
    //AppDelegate *app = [[UIApplication sharedApplication]delegate];
    //[app showMenu];
}

- (void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state)
    {
        //根据被触摸手势的view计算得出坐标值
        CGPoint translation = [gesture translationInView:gesture.view];
        NSLog(@"%@", NSStringFromCGPoint(translation));
    }
    else
    {
        //AppDelegate *app = [[UIApplication sharedApplication]delegate];
        //[app showMenu];
    }
}

- (IBAction)registerButtonClicked:(id)sender {
    //ZZYSMSRegisterViewController *vc = [[ZZYSMSRegisterViewController alloc]init];
    //[self presentViewController:vc animated:NO completion:nil];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app jumpToMainAfterLogin];
}


- (IBAction)privateButtonClicked:(id)sender {
   // PrivateViewController *vc = [[PrivateViewController alloc]init];
    //[self presentViewController:vc animated:NO completion:nil];
}
@end
