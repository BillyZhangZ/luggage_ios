//
//  LLoginViewController.m
//  luggage
//
//  Created by 余海平 on 16/9/19.
//  Copyright © 2016年 张志阳. All rights reserved.
//

#import "LLoginViewController.h"
#import "LCommonTools.h"
#import "AppDelegate.h"
#import "config.h"
#import "LRegisterViewController.h"

@interface LLoginViewController ()<UITextFieldDelegate>
{
    UIImageView  *_logoImageView,*_backGroundImageView;
    UIImageView  *_nameImageView,*_passwordImageView,*_nameLineImageView,*_passwordLineImageView;
    UITextField  *_emailTextField,*_passwordTextField;
    UIButton     *_loginBtn,*_forgetPasswordBtn,*_newsHereBtn;
    
}
@end

#define TEXT_FONT   [UIFont fontWithName:@"Arial" size:16.0f]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation LLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initAndLayoutUI];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)initAndLayoutUI {
    
    _backGroundImageView = [[UIImageView alloc]init];
    _backGroundImageView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview:_backGroundImageView];
    _backGroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _logoImageView = [[UIImageView alloc]init];
    _logoImageView.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:_logoImageView];
    _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _nameImageView = [[UIImageView alloc]init];
    _nameImageView.image = [UIImage imageNamed:@"name.png"];
    [self.view addSubview:_nameImageView];
    _nameImageView.translatesAutoresizingMaskIntoConstraints = NO;
//    _nameImageView.backgroundColor = [UIColor purpleColor];
    
    _emailTextField  = [[UITextField alloc] init];
//    _emailTextField.background = [[UIImage imageNamed:@"blue_line.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    _emailTextField.placeholder = @"Name";
    [_emailTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_emailTextField setValue:TEXT_FONT forKeyPath:@"_placeholderLabel.font"];
    _emailTextField.font = TEXT_FONT;
    _emailTextField.textColor = [UIColor whiteColor];
    _emailTextField.backgroundColor = [UIColor clearColor];
    _emailTextField.borderStyle = UITextBorderStyleNone;
    _emailTextField.secureTextEntry = NO;
    _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailTextField.clearsOnBeginEditing = YES;
    _emailTextField.textAlignment = NSTextAlignmentLeft;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailTextField.returnKeyType = UIReturnKeyDone;
    _emailTextField.delegate = self;
    [self.view addSubview:_emailTextField];
    _emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
//    _emailTextField.backgroundColor = [UIColor redColor];

    _nameLineImageView = [[UIImageView alloc]init];
//    _nameLineImageView.image = [UIImage imageNamed:@"blue_line.png"];
    _nameLineImageView.backgroundColor = UIColorFromRGB(0x035c80);
    [self.view addSubview:_nameLineImageView];
    _nameLineImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _passwordImageView = [[UIImageView alloc]init];
    _passwordImageView.image = [UIImage imageNamed:@"phone.png"];
    [self.view addSubview:_passwordImageView];
    _passwordImageView.translatesAutoresizingMaskIntoConstraints = NO;

    _passwordTextField = [[UITextField alloc] init];
//    _passwordTextField.background = [[UIImage imageNamed:@"blue_line.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    _passwordTextField.placeholder = @"Password";
    [_passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTextField setValue:TEXT_FONT forKeyPath:@"_placeholderLabel.font"];
    _passwordTextField.font = TEXT_FONT;
    _passwordTextField.textColor = [UIColor whiteColor];
    _passwordTextField.backgroundColor = [UIColor clearColor];
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.secureTextEntry = NO;
    _passwordTextField.clearsOnBeginEditing = YES;
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.keyboardType = UIKeyboardTypeDefault;
    _passwordTextField.returnKeyType = UIKeyboardTypeDefault;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
    _passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _passwordLineImageView = [[UIImageView alloc]init];
//    _passwordLineImageView.image = [UIImage imageNamed:@"blue_line.png"];
    _passwordLineImageView.backgroundColor = UIColorFromRGB(0x035c80);
    [self.view addSubview:_passwordLineImageView];
    _passwordLineImageView.translatesAutoresizingMaskIntoConstraints = NO;

  
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = [UIColor clearColor];
    [_loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _loginBtn.layer.borderWidth = 1;
    _loginBtn.layer.borderColor = UIColorFromRGB(0x035c80).CGColor;//[UIColor whiteColor].CGColor;
    _loginBtn.layer.cornerRadius = 20;
    [_loginBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 50)];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    _loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPasswordBtn.backgroundColor = [UIColor clearColor];
    [_forgetPasswordBtn setTitle:@"Forget password?" forState:UIControlStateNormal];
    [_forgetPasswordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_forgetPasswordBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPasswordBtn];
    _forgetPasswordBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _newsHereBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _newsHereBtn.backgroundColor = [UIColor clearColor];
    [_newsHereBtn setTitle:@"New here?Sign up" forState:UIControlStateNormal];
    [_newsHereBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _newsHereBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_newsHereBtn addTarget:self action:@selector(registerFuction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_newsHereBtn];
    _newsHereBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(_backGroundImageView,_logoImageView,_emailTextField,_passwordTextField,_loginBtn,_forgetPasswordBtn,_newsHereBtn,_nameImageView,_nameLineImageView,_passwordImageView,_passwordLineImageView);
    
    NSDictionary  *metrics = @{@"horizontalGap":@15,@"verticalGap":@10};
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backGroundImageView(>=0)]-0-|" options:0 metrics:nil views:viewsDic]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backGroundImageView(>=0)]-0-|" options:0 metrics:nil views:viewsDic]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_logoImageView(>=0)]-(>=0)-|" options:0 metrics:nil views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizontalGap)-[_nameImageView(==20)]-[_emailTextField(>=0)]-(==horizontalGap)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizontalGap)-[_nameLineImageView(>=0)]-(==horizontalGap)-|" options:0 metrics:metrics views:viewsDic]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizontalGap)-[_passwordImageView(==20)]-[_passwordTextField(>=0)]-(==horizontalGap)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizontalGap)-[_passwordLineImageView(>=0)]-(==horizontalGap)-|" options:0 metrics:metrics views:viewsDic]];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_loginBtn(>=0)]-(>=0)-|" options:0 metrics:nil views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_forgetPasswordBtn(>=0)]-(>=0)-|" options:0 metrics:nil views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_newsHereBtn(>=0)]-(>=0)-|" options:0 metrics:nil views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_logoImageView(>=0)]-60-[_emailTextField(==35)]-0-[_nameLineImageView(==1)]-(==15)-[_passwordTextField(==_emailTextField)]-2-[_passwordLineImageView(==1)]-35-[_loginBtn(>=0)]-0-[_forgetPasswordBtn(>=0)]-(>=0)-[_newsHereBtn(>=0)]-0-|" options:0 metrics:metrics views:viewsDic]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loginBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_forgetPasswordBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsHereBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_emailTextField attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passwordTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_passwordImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:10]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_nameImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:10]];


}
#pragma mark -- UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;

}
#pragma mark -- login
- (void)login {

    if ([LCommonTools isBlankString:_emailTextField.text]||[LCommonTools isBlankString:_passwordTextField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed!" message:@"Email or password can not be null" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
    
        [self loginRequest];
    }
}
#pragma mark -- loginRequest(get from old code)
- (void)loginRequest {

    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_USER_LOGIN];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100.0f];
    NSString *string;
    
    string = [[NSString alloc] initWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\"}",_emailTextField.text, _passwordTextField.text];
    
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
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app.account setUserId: [dict objectForKey:@"id"] ];
            [app.account setLocalPhoneNumber: [dict objectForKey:@"phoneNumber"]];
            [app.account setUserName:[dict objectForKey:@"name"]];
            [app.account setEmail:  [dict objectForKey:@"email"]];
            [app.account setDeviceId:[dict objectForKey:@"deviceId"]];
            [app.account setRemotePhoneNumber:[dict objectForKey:@"deviceSim"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Succeed" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                
                void (^onAfterSignUp)(UIAlertAction *action) = ^(UIAlertAction *action) {
                    
                    [app showMainView];
                };
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:onAfterSignUp];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }else{
            //出现错误；
            NSLog(@"error：%@",error);
        }
        
    }];
    
    [dataTask resume];

}
#pragma mark -- forgetPassword
- (void)forgetPassword {

    NSLog(@"forget Password");
    
}
#pragma mark -- registerFuction
- (void)registerFuction {

    LRegisterViewController  *registerView = [LRegisterViewController new];
    [self.navigationController pushViewController:registerView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
