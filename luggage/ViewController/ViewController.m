//
//  MainViewController.m
//  luggage
//
//  Created by 张志阳 on 11/29/15.
//  Copyright © 2015 张志阳. All rights reserved.
//
#import "AppDelegate.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ViewController.h"
#import "LocateViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigatorBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    say(@"welcome");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onShareButton:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app sendTextContent:@"Luggage, 让旅行更放心" withScene:WXSceneSession];
}

- (IBAction)onLocateButton:(id)sender {
    LocateViewController *vc = [[LocateViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
