//
//  AppDelegate.h
//  luggage
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZZYAcount.h"
#import "ZZYSetting.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZZYAcount *account;
@property (strong, nonatomic) ZZYSetting *setting;

@property NSInteger isDeviceBonded;

//微信分享接口声明
- (void) sendTextContent: (NSString *)text withScene:(int)scene;
- (void) sendImageContent: (UIImage*)viewImage withScene:(int)scene;
- (void) hideMenu;
- (void) showMenu;
- (void) onMenuItemClicked:(NSString *)itemName;
-(void)jumpToMainAfterLogin;
-(void)jumpToLoginVC;
-(void)setViewControllerAfterGuide;
void say(NSString *sth);
NSString * getATContent(NSString *str);
NSString * getATCmd(NSString *str);
-(void)sendBLECommad:(NSString *)cmd;
-(void)pushLocalNotification;
-(void)testServerNotification;

NSString * stringFromDate(NSDate *date);
CLLocationCoordinate2D  transformFromWGSToGCJ(CLLocationCoordinate2D wgLoc);
@end

