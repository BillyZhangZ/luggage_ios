//
//  AppDelegate.h
//  luggage
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "ZZYAcount.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZZYAcount *account;

//微信分享接口声明
- (void) sendTextContent: (NSString *)text withScene:(int)scene;
- (void) sendImageContent: (UIImage*)viewImage withScene:(int)scene;
- (void) hideMenu;
- (void) showMenu;
- (void) onMenuItemClicked:(NSString *)itemName;
-(void)jumpToMainVC;
void say(NSString *sth);
NSString * getATContent(NSString *str);

NSString * stringFromDate(NSDate *date);
CLLocationCoordinate2D  transformFromWGSToGCJ(CLLocationCoordinate2D wgLoc);
@end

