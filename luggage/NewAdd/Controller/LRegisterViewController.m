//
//  LRegisterViewController.m
//  luggage
//
//  Created by 余海平 on 16/9/20.
//  Copyright © 2016年 张志阳. All rights reserved.
//

#import "LRegisterViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import "ZZYBondDeviceIdVC.h"

@interface LRegisterViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{

    UITextField *_nickNameTextField,*_emailTextField,*_passwordTextField,*_phoneTextField;
    UIButton    *_signUpBtn;
    UIImageView *_backGroundImageView;

}
@end

#define TEXT_FONT   [UIFont fontWithName:@"Arial" size:16.0f]

@implementation LRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    [self inintAndLayoutUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}


- (void)inintAndLayoutUI {
    
    _backGroundImageView = [[UIImageView alloc]init];
    _backGroundImageView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview:_backGroundImageView];
    _backGroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _nickNameTextField = [[UITextField alloc] init];
    _nickNameTextField.backgroundColor = [UIColor whiteColor];
    _nickNameTextField.placeholder = @"Nick name";
    [_nickNameTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_nickNameTextField setValue:TEXT_FONT forKeyPath:@"_placeholderLabel.font"];
    _nickNameTextField.font = TEXT_FONT;
    _nickNameTextField.textColor = [UIColor grayColor];
    _nickNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _nickNameTextField.secureTextEntry = NO;
    _nickNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nickNameTextField.clearsOnBeginEditing = YES;
    _nickNameTextField.textAlignment = NSTextAlignmentLeft;
    _nickNameTextField.keyboardType =UIKeyboardTypeDefault ;
    _nickNameTextField.returnKeyType = UIReturnKeyDone;
    [_nickNameTextField becomeFirstResponder];
    _nickNameTextField.delegate = self;
    [self.view addSubview:_nickNameTextField];
    _nickNameTextField.translatesAutoresizingMaskIntoConstraints = NO;

    _emailTextField = [[UITextField alloc] init];
    _emailTextField.backgroundColor = [UIColor whiteColor];
    _emailTextField.placeholder = @"Email";
    [_emailTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_emailTextField setValue:TEXT_FONT forKeyPath:@"_placeholderLabel.font"];
    _emailTextField.font = TEXT_FONT;
    _emailTextField.textColor = [UIColor grayColor];
    _emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    _emailTextField.secureTextEntry = NO;
    _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailTextField.clearsOnBeginEditing = YES;
    _emailTextField.textAlignment = NSTextAlignmentLeft;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailTextField.returnKeyType = UIReturnKeyDone;
    _emailTextField.delegate = self;
    [self.view addSubview:_emailTextField];
    _emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.placeholder = @"Password";
    [_passwordTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTextField setValue:TEXT_FONT forKeyPath:@"_placeholderLabel.font"];
    _passwordTextField.font = TEXT_FONT;
    _passwordTextField.textColor = [UIColor grayColor];
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.secureTextEntry = NO;
    _passwordTextField.clearsOnBeginEditing = YES;
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.keyboardType = UIKeyboardTypeDefault;
    _passwordTextField.returnKeyType = UIKeyboardTypeDefault;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
    _passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.backgroundColor = [UIColor whiteColor];
    _phoneTextField.placeholder = @"Phone number";
    [_phoneTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTextField setValue:TEXT_FONT forKeyPath:@"_placeholderLabel.font"];
    _phoneTextField.font = TEXT_FONT;
    _phoneTextField.textColor = [UIColor grayColor];
    _phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    _phoneTextField.secureTextEntry = NO;
    _phoneTextField.clearsOnBeginEditing = YES;
    _phoneTextField.textAlignment = NSTextAlignmentLeft;
    _phoneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _phoneTextField.returnKeyType = UIKeyboardTypeDefault;
    _phoneTextField.secureTextEntry = YES;
    _phoneTextField.delegate = self;
    [self.view addSubview:_phoneTextField];
    _phoneTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    _signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signUpBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.2 alpha:1.0];;
    [_signUpBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signUpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_signUpBtn addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signUpBtn];
    _signUpBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(_backGroundImageView,_nickNameTextField,_emailTextField,_passwordTextField,_phoneTextField,_signUpBtn);
    
    NSDictionary *metrics = @{@"horizolGap":@40,@"verticalGap":@10};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backGroundImageView(>=0)]-0-|" options:0 metrics:nil views:viewsDic]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backGroundImageView(>=0)]-0-|" options:0 metrics:nil views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizolGap)-[_nickNameTextField(>=0)]-(==horizolGap)-|" options:0 metrics:metrics views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizolGap)-[_emailTextField(>=0)]-(==horizolGap)-|" options:0 metrics:metrics views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizolGap)-[_passwordTextField(>=0)]-(==horizolGap)-|" options:0 metrics:metrics views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizolGap)-[_phoneTextField(>=0)]-(==horizolGap)-|" options:0 metrics:metrics views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizolGap)-[_signUpBtn(>=0)]-(==horizolGap)-|" options:0 metrics:metrics views:viewsDic]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_nickNameTextField(==30)]-(==verticalGap)-[_emailTextField(==_nickNameTextField)]-(==verticalGap)-[_passwordTextField(==_nickNameTextField)]-(==verticalGap)-[_phoneTextField(==_nickNameTextField)]-20-[_signUpBtn(==40)]-(>=0)-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:viewsDic]];
}

#pragma mark - gesture response
-(void)tapHandle:(UITapGestureRecognizer *)tap
{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_nickNameTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
}
#pragma mark - signUp
- (void)signUp {

    
    if ([_passwordTextField.text isEqualToString: @""] || [_emailTextField.text isEqualToString: @""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed!" message:@"Items can not be null" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_USER_REGISTER];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100.0f];
    NSString *string;
    
    string = [[NSString alloc] initWithFormat:@"{\"name\":\"%@\",\"email\":\"%@\",\"password\":\"%@\",\"phoneNumber\":\"%@\"}",_nickNameTextField.text, _emailTextField.text, _passwordTextField.text, _phoneTextField.text];

    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if (dict == nil || [dict objectForKey:@"id"] == NULL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Please try later" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
                return ;
            }
            
            NSLog(@"%@", [dict objectForKey:@"id"]);
            if([[dict objectForKey:@"id"]integerValue] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Email exists" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
                return;
            }
            //store user id
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            app.account.userId = [dict objectForKey:@"id"];
#if 0
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulactions!" message:@"Succeed!" preferredStyle:UIAlertControllerStyleAlert];
                void (^onAfterSignUp)(UIAlertAction *action) = ^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                };
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:onAfterSignUp];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
#else
            dispatch_async(dispatch_get_main_queue(), ^{
                ZZYBondDeviceIdVC *vc = [[ZZYBondDeviceIdVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
      
            });
#endif
            
        }else{
            //出现错误；
            NSLog(@"error：%@",error);
        }
    }];

    
    
    [dataTask resume];
}
#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
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
