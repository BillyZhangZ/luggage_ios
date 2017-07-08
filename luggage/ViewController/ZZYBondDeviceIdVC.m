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
    UIImageView  *_logoImageView;
    UITextView   *_deviceNameView;
    UITextField  *_deviceIdTextField;
    UITextView   *_deviceSimView;
    UITextField  *_deviceSimTextField;
    UIButton    *_confirmButton;
}
@end
@implementation ZZYBondDeviceIdVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Device";
    
    /**
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    CGRect rc = rcScreen;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:rc];
    bgView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview: bgView];
    [self.view sendSubviewToBack:bgView];

    rc.size.height = 200;
    rc.size.width = 210;
    rc.origin.x = rcScreen.size.width/2 - rc.size.width/2;
    rc.origin.y = 64;
    _logoImageView = [[UIImageView alloc]initWithFrame:rc];
    _logoImageView.image = [UIImage imageNamed:@"device.png"];

    //device id label
    rc.size.width = 210;
    rc.origin.x = rcScreen.size.width/2 - rc.size.width/2;
    rc.origin.y = rc.origin.y + rc.size.height + 10;
    rc.size.height = 0;//30;
    _deviceNameView = [[UITextView alloc]initWithFrame:rc];
    _deviceNameView.editable = NO;
//    _deviceNameView.text = @"Device ID";
    [_deviceNameView.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor redColor])];
    [_deviceNameView.layer setBorderWidth:2.0];
    _deviceNameView.font = [UIFont systemFontOfSize:18];
    _deviceNameView.textColor = [UIColor whiteColor];
    _deviceNameView.backgroundColor = [UIColor clearColor];
    
    //device id textfield
    rc.origin.y += rc.size.height + 5;
    rc.size.height = 30;
    _deviceIdTextField = [[UITextField alloc]initWithFrame:rc];
    _deviceIdTextField.placeholder = @"Device ID";
    [_deviceIdTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_deviceIdTextField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _deviceIdTextField.clearsOnBeginEditing = YES;
    _deviceIdTextField.textColor = [UIColor whiteColor];
    _deviceIdTextField.font = [UIFont systemFontOfSize:18];
    [_deviceIdTextField setText:@""];
    _deviceIdTextField.backgroundColor = [UIColor clearColor];
    _deviceIdTextField.borderStyle = UITextBorderStyleRoundedRect;

    //device Sim label
    rc.origin.y += rc.size.height + 10;
    rc.size.height = 0;
    _deviceSimView = [[UITextView alloc]initWithFrame:rc];
    _deviceSimView.editable = NO;
//    _deviceSimView.text = @"Device Sim";
    [_deviceSimView.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor redColor])];
    [_deviceSimView.layer setBorderWidth:2.0];
    _deviceSimView.font = [UIFont systemFontOfSize:18];
    _deviceSimView.textColor = [UIColor whiteColor];
    _deviceSimView.backgroundColor = [UIColor clearColor];
    
    //device Sim textfield
    rc.origin.y += rc.size.height + 5;
    rc.size.height = 30;
    _deviceSimTextField = [[UITextField alloc]initWithFrame:rc];
    _deviceSimTextField.placeholder = @"Device Sim";
    [_deviceSimTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_deviceSimTextField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _deviceSimTextField.clearsOnBeginEditing = YES;
    _deviceSimTextField.textColor = [UIColor grayColor];
    [_deviceSimTextField setText:@""];
    _deviceSimTextField.backgroundColor = [UIColor clearColor];
    _deviceSimTextField.borderStyle = UITextBorderStyleRoundedRect;

    //done button
    rc.origin.y += rc.size.height + 30;
    rc.size.height = 44;
    _confirmButton = [[UIButton alloc]initWithFrame:rc];
//    _confirmButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.2 alpha:1.0];
    [_confirmButton setTitle:@"Done" forState:UIControlStateNormal];
    _confirmButton.backgroundColor = [UIColor clearColor];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _confirmButton.layer.borderWidth = 1;
    _confirmButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _confirmButton.layer.cornerRadius = 20;
    [_confirmButton setContentEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 50)];
    
    [_confirmButton addTarget:self action:@selector(onConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_logoImageView];
    [self.view addSubview:_deviceNameView];
    [self.view addSubview:_deviceIdTextField];
    [self.view addSubview:_deviceSimView];
    [self.view addSubview:_deviceSimTextField];
    [self.view addSubview:_confirmButton];
    _deviceIdTextField.delegate  = self;
    */
    
    [self initAndLayoutUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)initAndLayoutUI {

    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview: bgView];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;

    _logoImageView = [[UIImageView alloc]init];
    _logoImageView.image = [UIImage imageNamed:@"device.png"];
    [self.view addSubview:_logoImageView];
    _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    _deviceIdTextField = [[UITextField alloc]init];
    _deviceIdTextField.placeholder = @"Device ID";
    [_deviceIdTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_deviceIdTextField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _deviceIdTextField.clearsOnBeginEditing = YES;
    _deviceIdTextField.textColor = [UIColor whiteColor];
    _deviceIdTextField.font = [UIFont systemFontOfSize:18];
    [_deviceIdTextField setText:@""];
    _deviceIdTextField.backgroundColor = [UIColor clearColor];
    _deviceIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_deviceIdTextField];
    _deviceIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    _deviceSimTextField = [[UITextField alloc]init];
    _deviceSimTextField.placeholder = @"Device Sim";
    [_deviceSimTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_deviceSimTextField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _deviceSimTextField.clearsOnBeginEditing = YES;
    _deviceSimTextField.textColor = [UIColor grayColor];
    [_deviceSimTextField setText:@""];
    _deviceSimTextField.backgroundColor = [UIColor clearColor];
    _deviceSimTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_deviceSimTextField];
    _deviceSimTextField.translatesAutoresizingMaskIntoConstraints = NO;
    

    _confirmButton = [[UIButton alloc]init];
    [_confirmButton setTitle:@"Done" forState:UIControlStateNormal];
    _confirmButton.backgroundColor = [UIColor clearColor];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _confirmButton.layer.borderWidth = 1;
    _confirmButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _confirmButton.layer.cornerRadius = 20;
    [_confirmButton setContentEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 50)];
    [_confirmButton addTarget:self action:@selector(onConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    _confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(_logoImageView,_deviceIdTextField,_deviceSimTextField,_confirmButton);
    
    NSDictionary  *metrics = @{@"horizontalGap":@15,@"verticalGap":@10};
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bgView(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bgView(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgView)]];
    
    
    //160 *247
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_logoImageView(==120)]-(>=0)-|" options:0 metrics:metrics views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizontalGap)-[_deviceIdTextField(>=0)]-(==horizontalGap)-|" options:0 metrics:metrics views:viewsDic]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==horizontalGap)-[_deviceSimTextField(>=0)]-(==horizontalGap)-|" options:0 metrics:metrics views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_confirmButton(>=0)]-(>=0)-|" options:0 metrics:nil views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==100)-[_logoImageView(==180)]-(==20)-[_deviceIdTextField(==35)]-(==verticalGap)-[_deviceSimTextField(==35)]-(==20)-[_confirmButton(>=0)]-(>=0)-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:viewsDic]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    CGRect keyboardBounds;
    
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    NSLog(@"keyboardWillChangeFrame height is %f",keyboardBounds.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.frame = CGRectMake(0, -50, self.view.bounds.size.width, self.view.bounds.size.height + 100);
    }];
    
}


- (void)keyboardWillHide:(NSNotification *)note {

    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
        
    }];

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
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSInteger userId = [app.account.userId integerValue];
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_BOND_DEVICE];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100.0f];
    NSString *string;
    
    string = [[NSString alloc] initWithFormat:@"{\"userId\":\"%ld\",\"deviceId\":\"%ld\",\"deviceSim\":\"%@\"}",(long)userId, [_deviceIdTextField.text integerValue],_deviceSimTextField.text];
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
#ifdef NEW_MODIFY
                    [self.navigationController popToRootViewControllerAnimated:YES];
#else
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
#endif
                    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
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
#pragma mark - gesture response
-(void)tapHandle:(UITapGestureRecognizer *)tap
{
    [_deviceIdTextField resignFirstResponder];
    [_deviceSimTextField resignFirstResponder];
}

@end
