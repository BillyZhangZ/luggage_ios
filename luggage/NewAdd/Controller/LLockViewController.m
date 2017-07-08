//
//  LLockViewController.m
//  luggage
//
//  Created by 余海平 on 16/9/19.
//  Copyright © 2016年 张志阳. All rights reserved.
//

#import "LLockViewController.h"
#import "AppDelegate.h"

@interface LLockViewController ()
{
    UIButton  *_lockBtn;
}
@end

@implementation LLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];
    
    _lockBtn = [[UIButton alloc]init];
    [_lockBtn addTarget:self action:@selector(lockAction:) forControlEvents:UIControlEventTouchUpInside];
    [_lockBtn setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
    _lockBtn.selected = NO;
    _lockBtn.tintColor = [UIColor colorWithRed:0/255.0 green:161/255.0 blue:233/255.0 alpha:1.0]
;
    _lockBtn.layer.cornerRadius = 150/2;
    _lockBtn.layer.borderWidth = 8;
    _lockBtn.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/255.0 blue:233/255.0 alpha:1.0].CGColor;
    [self.view addSubview:_lockBtn];
    _lockBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_lockBtn(==150)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lockBtn)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_lockBtn(==150)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lockBtn)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lockBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lockBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];


    // Do any additional setup after loading the view.
}
#pragma mark-
#pragma mark- lockAction
- (void)lockAction:(id)sender {

    UIButton *btn = (UIButton*)sender;
    
    btn.selected = !btn.selected;
    
    if (btn.isSelected) {
        
        [self bleSendLock];
        [_lockBtn setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];

        
    }else {
        
        [self bleSendUnlock];
        [_lockBtn setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];

    }
    
}
#pragma mark-
#pragma mark- bleSendUnlock
-(void)bleSendUnlock
{
    NSLog(@"%@: send character\n",self);
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+LOCKOFF\r"];
}
#pragma mark-
#pragma mark- bleSendLock
-(void)bleSendLock
{
    NSLog(@"%@: send character\n",self);
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app sendBLECommad:@"AT+LOCKON\r"];
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
