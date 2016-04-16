//
//  XJSMSLoginVerifyViewController.m
//  Pao123
//
//  Created by 张志阳 on 15/6/28.
//  Copyright (c) 2015年 XingJian Software. All rights reserved.
//

#import "ZZYSMSLoginVerifyVC.h"
#import "AppDelegate.h"
#import "config.h"
#import "ZZYAcount.h"
#import <SMS_SDK/SMS_SDK.h>
#define TIME_OUT 60

@interface ZZYSMSLoginVerifyVC ()
{
    //UITapGestureRecognizer *tapGesture;
    NSTimer *_timer;
    NSInteger _verifyTimeout;
}
@end

@implementation ZZYSMSLoginVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.verifyButton setEnabled:NO];
    [self.verifyButton setTitle:@"60秒" forState:UIControlStateNormal];
    self.verifyButton.tintColor = [UIColor blackColor];
    self.verifyTextFiled.textColor = [UIColor grayColor];
    self.verifyTextFiled.layer.borderColor = [[UIColor blackColor] CGColor];

    //[self.verifyTextFiled becomeFirstResponder];
    self.verifyTextFiled.text = @"请输入验证码";
    [self startTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"login verify dealloc");
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
    self.verifyTextFiled.textColor = [UIColor blackColor];
    textField.text = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    if ([textField.text length] == 4) {
        [SMS_SDK commitVerifyCode:textField.text result:^(enum SMS_ResponseState state) {
            if (1==state)
            {
                NSLog(@"验证成功");
                [self releaseTimer];
              // [app.accountManager loginWithMobilePhone:_phoneNumber complete:^(bool ok){
                    if (true/*ok*/) {
                       // [app.account storeCurrentAccountInfo:_phoneNumber userId:@"0"];
                        app.account.localPhoneNumber = _phoneNumber;
                        app.account.userId = @"0";
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                        [app jumpToMainAfterLogin];
                    }
                    else
                    {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                        [alert addAction:okAction];

                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }
               // }];

            }
            else if(0==state)
            {
                NSLog(@"验证失败");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"验证失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];

                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }];
    }
   
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.verifyTextFiled) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 4){
            return NO;
        }
        NSString *text = nil;
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if (strLength == 4) {
            [self performSelector:@selector(delayResignResponsor) withObject:self afterDelay:0.3];
        }
    }
    return YES;
}

-(void)delayResignResponsor
{
    [self.verifyTextFiled resignFirstResponder];
}

- (IBAction)tapGestureOccured:(id)sender {
    [self.verifyTextFiled resignFirstResponder];
}
- (IBAction)verifyButtonClicked:(id)sender {
    
    //send request to server for sms
    UIButton *button = (UIButton *)sender;
    [button setEnabled:NO];
    [self startTimer];
    [button setTitle: [NSString stringWithFormat:@"%ld秒", (long)_verifyTimeout]  forState:UIControlStateNormal];
    button.tintColor = [UIColor blackColor];
}

-(void)onTimer:(NSTimer *)timer
{
    //just for test
    if (_verifyTimeout-- == 0)
    {
        [self releaseTimer];
        [self.verifyButton setEnabled:YES];
        [self.verifyButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        self.verifyButton.tintColor = [UIColor blackColor];

    }
    else
    {
        [self.verifyButton setTitle: [NSString stringWithFormat:@"%ld秒", (long)_verifyTimeout]  forState:UIControlStateNormal];
        self.verifyButton.tintColor = [UIColor blackColor];

    }
}

-(void)releaseTimer
{
    _verifyTimeout = TIME_OUT;
    [_timer invalidate];
    _timer = nil;
}
-(void)startTimer
{
    if (_timer == nil) {
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        _verifyTimeout = TIME_OUT;
    }
}
- (IBAction)swipeGestureOcurred:(id)sender {
    UISwipeGestureRecognizer *swipGuesture = (UISwipeGestureRecognizer *)sender;
    if (swipGuesture.direction == UISwipeGestureRecognizerDirectionRight) {
        //[self releaseTimer];
        
        //[self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (IBAction)backButtonClicked:(id)sender {
    [self releaseTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
