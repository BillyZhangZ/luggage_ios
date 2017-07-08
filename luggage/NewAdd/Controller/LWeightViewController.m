//
//  LWeightViewController.m
//  luggage
//
//  Created by 余海平 on 16/9/19.
//  Copyright © 2016年 张志阳. All rights reserved.
//

#import "LWeightViewController.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "BatteryView.h"
#import "UAProgressView.h"
#import <AVFoundation/AVFoundation.h>

@interface LWeightViewController ()
{
    float _distance;
    int   _rssiCount;
    int   _weightTestConut;
    ZZYAcount    *_account;
    UAProgressView   *_weightView;
    __block UIButton *_weightBtn;
}
@end


#define STANDARD_WEIGHT 50.0
#define BORDER_COLOR  [UIColor colorWithRed:0/255.0 green:161/255.0 blue:233/255.0 alpha:1.0]


@implementation LWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];

    [self initAndLayoutUI];
    
}
#pragma mark - initAndLayoutUI
- (void)initAndLayoutUI {

    _weightView = [[UAProgressView alloc]init];
    [self.view addSubview:_weightView];
    _weightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _weightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _weightBtn.userInteractionEnabled = NO;
    [_weightBtn setBackgroundImage:[UIImage imageNamed:@"weight_blue.png"] forState:UIControlStateNormal];
    [self.view addSubview:_weightBtn];
    _weightBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_weightView(==150)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_weightView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_weightView(==150)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_weightView)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_weightView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_weightView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_weightBtn(==75)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_weightBtn)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_weightBtn(==75)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_weightBtn)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_weightBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_weightBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self setWeightView];
}
#pragma mark - setWeightView
- (void)setWeightView {
    
    __weak LWeightViewController *weakSelf = self;
    
    _weightView.tintColor = BORDER_COLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.0, 100.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.numberOfLines = 2;
    label.textColor = BORDER_COLOR;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
//    label.text = @"Weight";
    _weightView.centralView = label;
    
    [_weightView setAnimationDuration:1.0];
    [_weightView setLineWidth:8];
    _weightView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
        
        [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%\n%.2flbs", progress * 100,progress*STANDARD_WEIGHT]];
    };
    
    _weightView.didSelectBlock = ^(UAProgressView *progressView) {
        [weakSelf getWeightWithBleSend];
        //AppDelegate* app = [[UIApplication sharedApplication]delegate];
        //[app setValue:[NSString stringWithFormat:@"%f",31.0f] forKey:@"weight"];
        //[app testServerNotification];
    };
}
#pragma mark - getWeightWithBleSend
-(void)getWeightWithBleSend
{
    NSLog(@"ViewController: send character\n");
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+GTWT\r"];
#if 1
    NSString *weight = @"0.0";
    if (_weightTestConut == 0) {
        weight = @"49.0";
        _weightTestConut++;
    } else if (_weightTestConut == 1) {
        weight = @"4.5";
        _weightTestConut++;
    } else if (_weightTestConut == 2) {
        weight = @"16.5";
        _weightTestConut++;
    } else {
        _weightTestConut = 0;
        weight = @"23.0";
    }
    
    
    if ([weight isEqualToString:@"0.0"]) {
        
        _weightBtn.hidden = NO;
    }else {
    
        _weightBtn.hidden = YES;
    }
    
    
    [_weightView setProgress:[weight floatValue]/STANDARD_WEIGHT animated:YES];
#endif
}
#pragma mark - shake
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"%s %d",__func__,__LINE__);
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0f];
        CGRect rc = _weightView.frame;
        rc.origin.y += 50;
        [_weightView setFrame:rc];
        [UIView commitAnimations];
    }
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
