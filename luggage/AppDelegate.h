//
//  AppDelegate.h
//  luggage
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//微信分享接口声明
- (void) sendTextContent: (NSString *)text withScene:(int)scene;
- (void) sendImageContent: (UIImage*)viewImage withScene:(int)scene;
-(void)jumpToMainVC;
void say(NSString *sth);
@end

