//
//  LoginViewController.m
//  luggage
//
//  Created by 张志阳 on 11/29/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import "ZZYLoginVC.h"
#import "config.h"
#import "ZZYRegisterVC.h"
#import "AppDelegate.h"
@interface ZZYLoginVC ()<UIGestureRecognizerDelegate>

@end

@implementation ZZYLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    CGRect rc = rcScreen;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:rc];
    bgView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview: bgView];
    [self.view sendSubviewToBack:bgView];
    
    self.emailTextField.textColor = [UIColor grayColor];
    self.passwordTextField.textColor = [UIColor grayColor];
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    //make it center
    rc.origin.x = rcScreen.size.width/2 - self.emailTextField.frame.size.width/2 ;
    rc.origin.y = self.emailTextField.frame.origin.y;
    
    rc.size.width = self.emailTextField.frame.size.width;
    rc.size.height = self.emailTextField.frame.size.height;
    
    [self.emailTextField setFrame:rc];
    rc.origin.y = self.passwordTextField.frame.origin.y;
    [self.passwordTextField setFrame:rc];
    
    rc.origin.y = self.logo.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - self.logo.frame.size.width/2;
    rc.size.width = self.logo.frame.size.width;
    rc.size.height = self.logo.frame.size.height;
    
    [self.logo setFrame:rc];
    
    rc.origin.y = self.signInButton.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - self.signInButton.frame.size.width/2;
    rc.size.width = self.signInButton.frame.size.width;
    rc.size.height = self.signInButton.frame.size.height;
    [self.signInButton setFrame:rc];
    
    rc.origin.y = self.forgotButton.frame.origin.y;
    rc.origin.x = rcScreen.size.width/2 - self.forgotButton.frame.size.width/2;
    rc.size.width = self.forgotButton.frame.size.width;
    rc.size.height = self.forgotButton.frame.size.height;
    
    [self.forgotButton setFrame:rc];
    
    rc.origin.y = rcScreen.size.height - self.signUpButton.frame.size.height;
    rc.origin.x = rcScreen.size.width/2 - self.signUpButton.frame.size.width/2;
    rc.size.width = self.signUpButton.frame.size.width;
    rc.size.height = self.signUpButton.frame.size.height;
    
    [self.signUpButton setFrame:rc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textColor = [UIColor blackColor];
    textField.text = @"";
    if (_passwordTextField == textField) {
        self.passwordTextField.secureTextEntry = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self defaultTextFieldContent:textField];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        return YES;
}

-(void)defaultTextFieldContent:(UITextField *)textField
{
    textField.textColor = [UIColor grayColor];
    if (textField == _emailTextField) {
        [textField setText:@"Email"];
    }
    else if(textField == _passwordTextField)
    {
        [textField setText:@"Password"];
        [textField setSecureTextEntry:NO];
    }
}

- (IBAction)onSignInButton:(id)sender {
    NSLog(@"Email: %@\nPassword:%@\n", self.emailTextField.text, self.passwordTextField.text);
    
    if ([_passwordTextField.text isEqualToString: @""] || [_emailTextField.text isEqualToString: @""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed!" message:@"Email or password can not be null" preferredStyle:UIAlertControllerStyleAlert];
       
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_USER_LOGIN];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100.0f];
    NSString *string;

    string = [[NSString alloc] initWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\"}",self.emailTextField.text, self.passwordTextField.text];
    
    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:10.0f];

    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict == nil || [dict objectForKey:@"id"] == NULL) {
                dispatch_async(dispatch_get_main_queue(), ^{

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                });
                return ;
            }
            
            NSLog(@"%@", [dict objectForKey:@"id"]);
            //store user id
            AppDelegate *app = [[UIApplication sharedApplication]delegate];
            [app.account setUserId: [dict objectForKey:@"id"] ];
            [app.account setLocalPhoneNumber: [dict objectForKey:@"phoneNumber"]];
            [app.account setUserName:[dict objectForKey:@"name"]];
            [app.account setEmail:  [dict objectForKey:@"email"]];
            [app.account setDeviceId:[dict objectForKey:@"deviceId"]];
          // if ((app.account.deviceId != nil )&& (![app.account.deviceId isEqualToString:@""]) ) {
          //      [app setValue:@"1" forKey:@"isDeviceBonded"];
          //  }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Succeed" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                void (^onAfterSignUp)(UIAlertAction *action) = ^(UIAlertAction *action) {
                    [app jumpToMainVC];
                };
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:onAfterSignUp];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
            /*
                        */
        }else{
            //出现错误；
            NSLog(@"error：%@",error);
        }
        
    }];
    
    
    [dataTask resume];

}

- (IBAction)onForgotButton:(id)sender {
    
}


- (IBAction)onSignUpButton:(id)sender {
    ZZYRegisterVC *registerVC = [[ZZYRegisterVC alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
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

#pragma mark - gesture response
-(void)tapHandle:(UITapGestureRecognizer *)tap
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
