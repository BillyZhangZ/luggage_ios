//
//  ZZYBondDeviceIdVC.m
//  luggage
//
//  Created by 张志阳 on 4/6/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import "ZZYBondDeviceIdVC.h"

#import "config.h"
#import "AppDelegate.h"

@interface ZZYBondDeviceIdVC()<UITextFieldDelegate>
{
    UIImageView *_logoImageView;
    UITextView *_deviceNameView;
    UITextField *_deviceIdTextField;
    UITextView *_deviceSimView;
    UITextField *_deviceSimTextField;
    
    UIButton *_confirmButton;
}
@end
@implementation ZZYBondDeviceIdVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    CGRect rc = rcScreen;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:rc];
    bgView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview: bgView];
    [self.view sendSubviewToBack:bgView];

    rc.size.height = 200;
    rc.size.width = 210;
    rc.origin.x = rcScreen.size.width/2 - rc.size.width/2;
    rc.origin.y = 40;
    _logoImageView = [[UIImageView alloc]initWithFrame:rc];
    _logoImageView.image = [UIImage imageNamed:@"device.png"];

    //device id label
    rc.size.width = 210;
    rc.origin.x = rcScreen.size.width/2 - rc.size.width/2;
    rc.origin.y = rc.origin.y + rc.size.height + 10;
    rc.size.height = 30;
    _deviceNameView = [[UITextView alloc]initWithFrame:rc];
    _deviceNameView.text = @"Device ID";
    [_deviceNameView.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor redColor])];
    [_deviceNameView.layer setBorderWidth:2.0];
    _deviceNameView.font = [UIFont systemFontOfSize:18];
    _deviceNameView.textColor = [UIColor whiteColor];
    _deviceNameView.backgroundColor = [UIColor clearColor];
    
    //device id textfield
    rc.origin.y += rc.size.height + 5;
    rc.size.height = 30;
    _deviceIdTextField = [[UITextField alloc]initWithFrame:rc];
    _deviceIdTextField.textColor = [UIColor grayColor];
    [_deviceIdTextField setText:@""];
    _deviceIdTextField.backgroundColor = [UIColor whiteColor];
    _deviceIdTextField.borderStyle = UITextBorderStyleRoundedRect;

    //device Sim label
    rc.origin.y += rc.size.height + 10;
    _deviceSimView = [[UITextView alloc]initWithFrame:rc];
    _deviceSimView.text = @"Device Sim";
    [_deviceSimView.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor redColor])];
    [_deviceSimView.layer setBorderWidth:2.0];
    _deviceSimView.font = [UIFont systemFontOfSize:18];
    _deviceSimView.textColor = [UIColor whiteColor];
    _deviceSimView.backgroundColor = [UIColor clearColor];
    
    //device Sim textfield
    rc.origin.y += rc.size.height + 5;
    rc.size.height = 30;
    _deviceSimTextField = [[UITextField alloc]initWithFrame:rc];
    _deviceSimTextField.textColor = [UIColor grayColor];
    [_deviceSimTextField setText:@""];
    _deviceSimTextField.backgroundColor = [UIColor whiteColor];
    _deviceSimTextField.borderStyle = UITextBorderStyleRoundedRect;

    //done button
    rc.origin.y += rc.size.height + 20;
    rc.size.height = 44;
    _confirmButton = [[UIButton alloc]initWithFrame:rc];
    _confirmButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.2 alpha:1.0];
    [_confirmButton setTitle:@"Done" forState:UIControlStateNormal];
    
    [_confirmButton addTarget:self action:@selector(onConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_logoImageView];
    [self.view addSubview:_deviceNameView];
    [self.view addSubview:_deviceIdTextField];
    [self.view addSubview:_deviceSimView];
    [self.view addSubview:_deviceSimTextField];
    [self.view addSubview:_confirmButton];
    _deviceIdTextField.delegate  = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}


-(void)onConfirmButton:(id)sender
{
    if ((_deviceIdTextField.text.length ==0) || (_deviceIdTextField.text.length == 0)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Device ID can not be null" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    int userId = [app.account.userId integerValue];
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_BOND_DEVICE];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100.0f];
    NSString *string;
    
    string = [[NSString alloc] initWithFormat:@"{\"userId\":\"%d\",\"deviceId\":\"%d\",\"deviceSim\":\"%@\"}",userId, [_deviceIdTextField.text integerValue],_deviceSimTextField.text];
    NSLog(@"%@", string);
    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if (dict == nil || [[dict objectForKey:@"ok"] integerValue] != 1) {
                dispatch_async(dispatch_get_main_queue(), ^{

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                });
                return ;
            }
            
            NSLog(@"%@", [dict objectForKey:@"id"]);
           
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Bonded" message:@"Bond device OK" preferredStyle:UIAlertControllerStyleAlert];
                void (^onAfterSignUp)(UIAlertAction *action) = ^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                    AppDelegate *app = [[UIApplication sharedApplication]delegate];
                    [app.account setDeviceId:_deviceIdTextField.text];
                };
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:onAfterSignUp];
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
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}



#pragma mark - gesture response
-(void)tapHandle:(UITapGestureRecognizer *)tap
{
    [_deviceIdTextField resignFirstResponder];
    [_deviceSimTextField resignFirstResponder];
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
