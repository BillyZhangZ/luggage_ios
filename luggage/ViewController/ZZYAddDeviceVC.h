//
//  BLEViewController.h
//  luggage
//
//  Created by 张志阳 on 12/6/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SET_NAME     @"AT+STNAME=ZHIYANG\r"
#define GET_NAME     @"AT+GTNAME\r"
#define GET_SIM_NUMBER      @"AT+GTSIM\r"
#define GET_WEIGHT   @"AT+GTWT\r"
#define GET_MODE     @"AT+GTMD\r"
#define GET_DEV_INFO      @"AT+GTDEV\r"
#define GET_BAT      @"AT+GTBAT\r"
#define GET_SW_VER    @"AT+GTSTVER\r"

#define LOCK        @"AT+LOCKON\r"
#define UNLOCK      @"AT+LOCKOFF\r"


@interface ZZYAddDeviceVC : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *logText;
@end
