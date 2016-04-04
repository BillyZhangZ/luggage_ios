//
//  ZZYRegisterVC.m
//  luggage
//
//  Created by 张志阳 on 4/4/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import "ZZYRegisterVC.h"
#import "config.h"
#import "AppDelegate.h"
@interface ZZYRegisterVC()
{
    UIImageView *_logoImageView;
    UITextField *_nameTextField;
    UITextField *_emailTextField;
    UITextField *_passwordTextField;
    UITextField *_phoneTextField;
    UIButton *_confirmButton;
}
@end
@implementation ZZYRegisterVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    CGRect rc = rcScreen;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:rc];
    bgView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview: bgView];
    [self.view sendSubviewToBack:bgView];
    
    rc.size.height = 140;
    rc.size.width = 210;
    rc.origin.x = rcScreen.size.width/2 - rc.size.width/2;
    rc.origin.y = 100;
    _logoImageView = [[UIImageView alloc]initWithFrame:rc];
    _logoImageView.image = [UIImage imageNamed:@"location1.png"];
    
    rc.size.width = 210;
    rc.origin.x = rcScreen.size.width/2 - rc.size.width/2;
    rc.origin.y = rc.origin.y + rc.size.height + 10;
    rc.size.height = 30;
    _nameTextField = [[UITextField alloc]initWithFrame:rc];
    
    rc.origin.y += rc.size.height + 10;
    _emailTextField = [[UITextField alloc]initWithFrame:rc];
    
    rc.origin.y += rc.size.height + 10;
    _passwordTextField = [[UITextField alloc]initWithFrame:rc];
    
    rc.origin.y += rc.size.height + 10;
    _phoneTextField = [[UITextField alloc]initWithFrame:rc];
    _phoneTextField.textColor =
    _nameTextField.textColor =
    _emailTextField.textColor =
    _passwordTextField.textColor = [UIColor grayColor];
    [_nameTextField setText:@"Nick name"];
    [_emailTextField setText:@"Email"];
    [_passwordTextField setText:@"Password"];
    [_phoneTextField setText:@"Phone number"];

    _phoneTextField.backgroundColor = _nameTextField.backgroundColor =  _emailTextField.backgroundColor = _passwordTextField.backgroundColor = [UIColor whiteColor];
    _phoneTextField.borderStyle = _nameTextField.borderStyle = _emailTextField.borderStyle = _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [_emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    
    rc.origin.y += rc.size.height + 20;
    rc.size.height = 44;
    _confirmButton = [[UIButton alloc]initWithFrame:rc];
    _confirmButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.2 alpha:1.0];
    [_confirmButton setTitle:@"Sign up" forState:UIControlStateNormal];
    
    [_confirmButton addTarget:self action:@selector(onConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nameTextField];
    [self.view addSubview:_logoImageView];
    [self.view addSubview:_emailTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:_confirmButton];
    [self.view addSubview:_phoneTextField];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}


-(void)onConfirmButton:(id)sender
{
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_USER_REGISTER];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100.0f];
    NSString *string;
    
    string = [[NSString alloc] initWithFormat:@"{\"name\":\"%@\",\"email\":\"%@\",\"password\":\"%@\",\"phoneNumber\":\"%@\"}",_nameTextField.text, _emailTextField.text, _passwordTextField.text, _phoneTextField.text];
    NSLog(@"%@", string);
    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

            if (dict == nil || [dict objectForKey:@"id"] == NULL) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"位置数据格式错误" message:@"请再试一下下" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            NSLog(@"%@", [dict objectForKey:@"id"]);
            //store user id
            AppDelegate *app = [[UIApplication sharedApplication]delegate];
            app.account.userId = [dict objectForKey:@"id"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulactions!" message:@"Succeed!" preferredStyle:UIAlertControllerStyleAlert];
            void (^onAfterSignUp)(UIAlertAction *action) = ^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            };

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:onAfterSignUp];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            //[self dismissViewControllerAnimated:NO completion:nil];
        }else{
            //出现错误；
            NSLog(@"错误信息：%@",error);
        }
    }];
    
    
    [dataTask resume];
}

-(void)onAfterSignUp
{
    
}

#pragma mark - gesture response
-(void)tapHandle:(UITapGestureRecognizer *)tap
{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
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
