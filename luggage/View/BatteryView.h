//
//  BatteryView.h
//  luggage
//
//  Created by 张志阳 on 4/12/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatteryView : UIView
@property (strong,nonatomic) UILabel *cell1;
@property (strong,nonatomic) UILabel *cell2;
@property (strong,nonatomic) UILabel *cell3;
@property  (nonatomic) NSInteger batttery;

#define BATTERY_0    0
#define BATTERY_33   1
#define BATTERY_66   2
#define BATTERY_100  3
@end
