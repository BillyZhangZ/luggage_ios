//
//  LMainBaseViewController.m
//  luggage
//
//  Created by 余海平 on 16/9/20.
//  Copyright © 2016年 张志阳. All rights reserved.
//

#import "LMainBaseViewController.h"
#import "ZZYAddDeviceVC.h"
#import "AppDelegate.h"
#import "BatteryView.h"
#import "LMenuViewController.h"

@interface LMainBaseViewController ()
{

    BatteryView  *_batView;
    UIButton     *rightBtn;
}
@end

@implementation LMainBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];

    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    [rightBtn setImage:[UIImage imageNamed:@"battery100.png"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"Bond" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];;
    
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(- (rightBtn.frame.size.height - rightBtn.titleLabel.frame.size.height- rightBtn.titleLabel.frame.origin.y),(rightBtn.frame.size.width -rightBtn.titleLabel.frame.size.width)/2.0f -rightBtn.imageView.frame.size.width - 10, 0, 0);
    
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(rightBtn.frame.size.height-rightBtn.imageView.frame.size.height-rightBtn.imageView.frame.origin.y, 15, -8, 0);
    
//    rightBtn.backgroundColor = [UIColor redColor];
//    rightBtn.imageView.backgroundColor = [UIColor orangeColor];
//    rightBtn.titleLabel.backgroundColor = [UIColor purpleColor];
    
    rightBtn.titleLabel.contentMode = UIViewContentModeLeft;
    
    [rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self addAppdelegateObserver];

}



#pragma mark - addAppdelegateObserver
- (void)addAppdelegateObserver {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app addObserver:self forKeyPath:@"distance" options:NSKeyValueObservingOptionNew context:nil];
    [app addObserver:self forKeyPath:@"battery" options:NSKeyValueObservingOptionNew context:nil];
    [app addObserver:self forKeyPath:@"weight" options:NSKeyValueObservingOptionNew context:nil];
    
}
#pragma mark - observeValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if ([keyPath isEqualToString:@"distance"]) {
        //check if alert according to setting
        if (![app.setting.alertSetting boolValue]) {
            return;
        }
        NSString * distance = [change valueForKey:NSKeyValueChangeNewKey];
        if ([distance floatValue] > 6) {
            [app pushLocalNotification];
        }
        NSLog(@"distance is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    }
    else if([keyPath isEqualToString:@"battery"])
    {
        NSString *battery = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"battery is changed! new=%@", battery);
        
        NSInteger cellBatt = [battery integerValue];
        
        if ((cellBatt >= 0) && (cellBatt < 20)) {
            cellBatt = BATTERY_0;
        } else if ((cellBatt >= 20) && (cellBatt < 50)) {
            cellBatt = BATTERY_33;
        } else if ((cellBatt >= 50) && (cellBatt < 80)) {
            cellBatt = BATTERY_66;
        } else if ((cellBatt >= 80) && (cellBatt < 100)) {
            cellBatt = BATTERY_100;
        } else {
            cellBatt = BATTERY_0;
        }
        
        //   if ([battery integerValue] != _batView.batttery) {
        [_batView setBatttery:cellBatt];//修改 换图片
        // }
        
        switch (cellBatt) {
            case BATTERY_0:
                
                [rightBtn setImage:[UIImage imageNamed:@"battery0.png"] forState:UIControlStateNormal];

                break;
            case BATTERY_33:
               
                [rightBtn setImage:[UIImage imageNamed:@"battery33.png"] forState:UIControlStateNormal];

                break;
            case BATTERY_66:
                [rightBtn setImage:[UIImage imageNamed:@"battery66.png"] forState:UIControlStateNormal];
                
                break;
            case BATTERY_100:
                [rightBtn setImage:[UIImage imageNamed:@"battery100.png"] forState:UIControlStateNormal];
                
                break;
                
            default:
                break;
        }
        
    }
    else if([keyPath isEqualToString:@"weight"])
    {
        NSString *weight = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"weight is changed! new=%@", weight);
        /*[_weightView setProgress:[weight floatValue]/STANDARD_WEIGHT animated:YES];*/
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)rightButtonClick {

    ZZYAddDeviceVC *bondView = [ZZYAddDeviceVC new];
    bondView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bondView animated:YES];
    
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
