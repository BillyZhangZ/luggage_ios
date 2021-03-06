//
//  AppDelegate.m
//  luggage
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZYMainVC.h"
#import "ZZYLocateVC.h"
#import "ZZYSMSLoginVC.h"
#import "WXApi.h"
#import "config.h"
#import "ZZYMenuView.h"
#import <SMS_SDK/SMS_SDK.h>
//#import <MAMapKit/MAMapKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZZYBookTicketVC.h"
#import "ZZYFootprintVC.h"
#import "ZZYWebsiteVC.h"
#import "ZZYSettingsVC.h"
#import "ZZYUserVC.h"
#import "ZZYFingerManageVC.h"
#import "BLEDevice.h"
#import "ZZYUserGuideVC.h"
#import "ZZYLoginVC.h"
#import "ZZYBondDeviceIdVC.h"

#import "LLoginViewController.h"
#import "LGpsViewController.h"
#import "LLockViewController.h"
#import "LWeightViewController.h"
#import "LMenuViewController.h"
#import "ZZYUserGuideView.h"
#import "ZZYMenuView.h"


#define UPDATE_BATTERY_COUNTER 60

@interface AppDelegate ()<WXApiDelegate, LuggageDelegate>
{
    ZZYMainVC * _mainVC;
    ZZYMenuView *_menuView;
    ZZYLoginVC *_loginVC;
    
    NSString *_deviceToken;
    
    LuggageDevice *_luggageDevice;
    CBPeripheral *_foundDev;
    NSTimer *_updateRssiTimer;
    int readBatteryCounter;
    BOOL _bleState;
    int FINGERREG;
    int FINGERDEL;
    float distance;
    float battery ;
    float weight;
    
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef NEW_MODIFY

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self initVaribles];
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
        [self showLoginView];
        [self.window makeKeyAndVisible];
        
        ZZYUserGuideView *guideView = [[ZZYUserGuideView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window addSubview:guideView];
        [self.window bringSubviewToFront:guideView];
    }
    else
    {
        NSLog(@"not first start");
        if (_account.localPhoneNumber == nil || [_account.localPhoneNumber isEqualToString: @"0"]) {
            
            [self showLoginView];
        }
        else
        {
            if (_isDeviceBonded) {
                
                _luggageDevice = [[LuggageDevice alloc]init:self onlyScan:NO];
            }

            [self showMainView];
        
        }
        
        [self.window makeKeyAndVisible];

    }
    
    return YES;

#else

    _mainVC = [[ZZYMainVC alloc] init];
     _account = [[ZZYAcount alloc]init];
     _setting = [[ZZYSetting alloc]init];
     _loginVC = [[ZZYLoginVC alloc]init];
     _isDeviceBonded = [_account.bond integerValue];
     _bleState = false;
     FINGERREG = FINGERDEL = 0;
     
     readBatteryCounter = 0;
     distance = 0;
     battery = 0;
     weight = 0;
     
     [UIDevice currentDevice].proximityMonitoringEnabled = YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
     
     [self addObserver:self forKeyPath:@"isDeviceBonded" options:NSKeyValueObservingOptionNew context:nil];
     
     CGRect rc = [[UIScreen mainScreen] bounds];
     _menuView = [[ZZYMenuView alloc]initWithFrame:rc];
     [WXApi registerApp:@"wx9d60ab46bfa2d903" withDescription:@"luggage"];
     [SMS_SDK registerApp:@"cdabbcf0f504"  withSecret:@"ccbe1fa6a1f8f17075f03951b29d1618"];
     
     // let voice can be heard when app is at background, and use MIX to prevent pausing music player
     NSError *error = NULL;
     AVAudioSession *session = [AVAudioSession sharedInstance];
     [session setCategory:AVAudioSessionCategoryPlayback
     withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
     
     
     
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     
     
     float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
     if (sysVersion>=8.0) {
     UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
     UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
     [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
     }
     
     //判断是不是第一次启动应用
     if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
     {
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
     NSLog(@"first start");
     //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
     ZZYUserGuideVC *userGuideViewController = [[ZZYUserGuideVC alloc] init];
     self.window.rootViewController = userGuideViewController;
     self.window.backgroundColor = [UIColor whiteColor];
     
     }
     else
     {
     NSLog(@"not first start");
     if (_account.localPhoneNumber == nil || [_account.localPhoneNumber isEqualToString: @"0"]) {
     self.window.rootViewController = _loginVC;
     }
     else
     {
     if (_isDeviceBonded) {
     _luggageDevice = [[LuggageDevice alloc]init:self onlyScan:NO];
     }
     else
     {
     
     }
     self.window.rootViewController = _mainVC;
     }
     }
     
     [self.window makeKeyAndVisible];
    
    return YES;

#endif

}
#pragma mark - initVaribles
- (void)initVaribles {

    _account = [[ZZYAcount alloc]init];
    _isDeviceBonded = [_account.bond integerValue];
    _bleState = false;
    FINGERREG = FINGERDEL = 0;
    
    readBatteryCounter = 0;
    distance = 0;
    battery = 0;
    weight = 0;
    
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    [self addObserver:self forKeyPath:@"isDeviceBonded" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [WXApi registerApp:@"wx9d60ab46bfa2d903" withDescription:@"luggage"];
    [SMS_SDK registerApp:@"cdabbcf0f504"  withSecret:@"ccbe1fa6a1f8f17075f03951b29d1618"];
    
    // let voice can be heard when app is at background, and use MIX to prevent pausing music player
    NSError *error = NULL;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    
    if (sysVersion>=8.0) {
        
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }

}
#pragma mark -
#pragma mark - showLoginView
- (void)showLoginView {

    LLoginViewController *loginView = [[LLoginViewController alloc]init];
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginView];
    rootNav.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];
    self.window.rootViewController = rootNav;
}
#pragma mark - 
#pragma mark - showMainView
- (void)showMainView {


    LGpsViewController     *gpsView = [[LGpsViewController alloc]init];
    gpsView.title = @"Location";
    
    LLockViewController    *lockView = [[LLockViewController alloc]init];
    lockView.title = @"luggage";

    LWeightViewController  *weightView = [[LWeightViewController alloc]init];
    weightView.title = @"luggage";

    LMenuViewController    *menuView = [[LMenuViewController alloc]init];
    menuView.title = @"luggage";

    
    UINavigationController *gpsViewNav = [[UINavigationController alloc]initWithRootViewController:gpsView];
    UINavigationController *lockViewNav = [[UINavigationController alloc]initWithRootViewController:lockView];
    UINavigationController *weightViewNav = [[UINavigationController alloc]initWithRootViewController:weightView];
    UINavigationController *menuViewNav = [[UINavigationController alloc]initWithRootViewController:menuView];

    gpsViewNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    lockViewNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    weightViewNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    menuViewNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    
    [gpsViewNav setTabBarItem:[[UITabBarItem alloc]initWithTitle:@"Gps" image:GPS_IMGE selectedImage:GPS_ON_IMGE]];

    [lockViewNav setTabBarItem:[[UITabBarItem alloc]initWithTitle:@"Lock" image:LOCK_IMGE selectedImage:LOCK_ON_IMGE]];

    [weightViewNav setTabBarItem:[[UITabBarItem alloc]initWithTitle:@"Weight" image:WEIGHT_IMGE selectedImage:WEIGHT_ON_IMGE]];
    
    [menuViewNav setTabBarItem:[[UITabBarItem alloc]initWithTitle:@"Menu" image:MENU_IMGE selectedImage:MENU_ON_IMGE]];

    
    self.tabbarController = [[UITabBarController alloc]init];

    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11], NSFontAttributeName, UIColorFromRGB(0x929292), NSForegroundColorAttributeName,nil]   forState:UIControlStateNormal];
    
    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11], NSFontAttributeName,  UIColorFromRGB(0x00bcd4), NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    self.tabbarController.tabBar.backgroundImage = [UIImage imageNamed:@"bar.png"];

    
    [self.tabbarController setViewControllers:@[gpsViewNav,lockViewNav,weightViewNav,menuViewNav]];
    
    self.window.rootViewController = self.tabbarController;

}
#pragma mark -
#pragma mark - observeValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _account.bond = [change valueForKey:NSKeyValueChangeNewKey];

    if ([keyPath isEqualToString:@"isDeviceBonded"]) {
        if([[change valueForKey:NSKeyValueChangeNewKey] integerValue] == 0)
        {
            [_luggageDevice BLEDisconnect];

            _luggageDevice = nil;
        }
        else
        {
            _luggageDevice = [[LuggageDevice alloc]init:self onlyScan:NO];
        }
    }
}
-(void)setViewControllerAfterGuide
{
    if (_account.localPhoneNumber == nil) {
        self.window.rootViewController = _loginVC;
    }
    else
    {
        self.window.rootViewController = _mainVC;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    application.applicationIconBadgeNumber = 0;
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //check the identifier
    if([shortcutItem.type isEqualToString:@"-11.UITouchText.share"]){
        NSArray *arr = @[@"Hi, I am using smart luggage. Join us now!"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        //use rootviewcontroller to present
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"receive remote notification");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@",deviceToken);
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    //modify the token, remove the  "<, >"
    NSLog(@"    deviceTokenStr  lentgh:  %lu  ->%@", (unsigned long)[deviceTokenStr length], [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)]);
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    
    NSLog(@"deviceTokenStr = %@",deviceTokenStr);
    _deviceToken = deviceTokenStr;
    //[self registerDeviceToken:deviceTokenStr];
}

-(void)registerDeviceToken:(NSString *)deviceToken
{
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_REGISTER_DEVICE_TOKEN];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100.0f];
    
    NSString *string;
    int userId = (int)[self.account.userId integerValue];

    string = [[NSString alloc] initWithFormat:@"{\"userId\":\"%d\",\"deviceToken\":\"%@\"}",userId,deviceToken];
    NSLog(@"%@", string);
    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if (dict == nil || [[dict objectForKey:@"ok"] integerValue] != 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Connect Server Failed" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                });
                return ;
            }
            
            NSLog(@"%@", [dict objectForKey:@"id"]);
            
            dispatch_async(dispatch_get_main_queue(), ^{

            });
            
        }else{
            //出现错误；
            NSLog(@"error：%@",error);
        }
    }];
    
    
    [dataTask resume];

}

-(void)testServerNotification
{
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_TEST_SERVER_NOTIFICATION];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100.0f];
    
    NSString *string;
    NSInteger userId = [self.account.userId integerValue];
    
    string = [[NSString alloc] initWithFormat:@"{\"userId\":\"%ld\"}",(long)userId];
    NSLog(@"%@", string);
    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            
        }else{
            //出现错误；
            NSLog(@"error：%@",error);
        }
    }];
    
    
    [dataTask resume];
    
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
#pragma mark -
#pragma mark - showMenu
- (void) showMenu
{
#if 0
    // update menu content
    if (self.accountManager.currentAccount.nickName == nil) {
        _menuView.lblName.text = self.accountManager.currentAccount.user;
    }
    else
        _menuView.lblName.text = self.accountManager.currentAccount.nickName;
#else
        _menuView.lblName.text = self.account.userName;
#endif
    
    CGRect rc = _menuView.frame;
    rc.origin.x = - lo_menu_width * rate_pixel_to_point;
    _menuView.frame = rc;
    [self.window addSubview:_menuView];
    
    // 动画执行开始
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDuration:0.7];
    // 设置要变化的frame 推入与推出修改对应的frame即可
    rc.origin.x = 0;
    _menuView.frame = rc;
    // 执行动画
    [UIView commitAnimations];
    
}
#pragma mark - 
#pragma mark - hideMenu
- (void) hideMenu
{
    CGRect rc = _menuView.frame;
    rc.origin.x = - lo_menu_width * rate_pixel_to_point;
    _menuView.frame = rc;
    [_menuView removeFromSuperview];
}
#pragma mark -
#pragma mark - onMenuItemClicked
- (void) onMenuItemClicked:(NSString *)itemName
{
    if([itemName compare:@"User"] == NSOrderedSame)
    {
#if 0
        if (_accountManager.currentAccount == _accountManager.guestAccount) {
            _window.rootViewController = _loginVC;
        }
        else
        {
            _window.rootViewController = _userVC;
        }
#else
        ZZYUserVC *vc = [[ZZYUserVC alloc]init];
        [_window.rootViewController presentViewController:vc
                                                 animated:YES completion:nil];
#endif
    }
    else if([itemName compare:@"Footprint"] == NSOrderedSame)
    {
        ZZYFootprintVC *vc = [[ZZYFootprintVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    else if([itemName compare:@"Flight"] == NSOrderedSame)
    {
        // _window.rootViewController = _histVC;
        ZZYBookTicketVC *vc = [[ZZYBookTicketVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    else if([itemName compare:@"Products"] == NSOrderedSame)
    {
        ZZYWebsiteVC *vc = [[ZZYWebsiteVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    else if([itemName compare:@"Add Device"] == NSOrderedSame)
    {
        ZZYBondDeviceIdVC *vc = [[ZZYBondDeviceIdVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    else if([itemName compare:@"Fingerprint"] == NSOrderedSame)
    {
        ZZYFingerManageVC *vc = [[ZZYFingerManageVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    else if([itemName compare:@"Settings"] == NSOrderedSame)
    {
        // _window.rootViewController = _settingsVC;
        ZZYSettingsVC *vc = [[ZZYSettingsVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    
    [self hideMenu];

}


#pragma  WX Delegate

/*该函数不用用户主动掉用*/
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        /*
         NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
         NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         alert.tag = 1000;
         [alert show];
         [alert release];*/
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        //显示微信传过来的内容
        /*
         ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
         WXMediaMessage *msg = temp.message;
         
         
         WXAppExtendObject *obj = msg.mediaObject;
         
         NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
         NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         [alert release];*/
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        /*
         NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
         NSString *strMsg = @"这是从微信启动的消息";
         */
    }
    
}
/*该函数不用用户主动掉用*/
-(void) onResp:(BaseResp*)resp
{
    //send to timeline or session reponse, runhelper can alert some info here
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        /*
         NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
         NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
         */
    }
    
}
/*分享图片给好友/朋友圈/收藏
 WXSceneSession 好友,
 WXSceneTimeline 朋友圈,
 WXSceneFavorite  收藏,
 */
-(void)sendImageContent: (UIImage*)viewImage withScene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"123go";
    message.description = @"让跑步称为一种习惯";
    message.mediaTagName = @"123go科技";
    [message setThumbImage:[UIImage imageNamed:@"maps.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(viewImage);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene =  scene;
    
    [WXApi sendReq:req];
    
    
    [WXApi sendReq:req];
    
}

/*分享文字给好友/朋友圈/收藏
 WXSceneSession 好友,
 WXSceneTimeline 朋友圈,
 WXSceneFavorite  收藏,
 */
- (void) sendTextContent: (NSString *)text withScene:(int)scene
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = text;//@"我的选择，叮叮跑步";
    req.bText = YES;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

void say(NSString *sth)
{
    if(YES)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        NSError *setCategoryError = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        
        NSError *activationError = nil;
        [audioSession setActive:YES error:&activationError];
        
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:sth];
        utterance.rate = 0.5f;
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[AVSpeechSynthesisVoice currentLanguageCode]];
        //        utterance.rate *= 0.5;
        //        utterance.pitchMultiplier = 0.5;
        
        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
        [synth speakUtterance:utterance];
    }
}

-(void)sendBLECommad:(NSString *)cmd
{
    [_luggageDevice LuggageWriteChar:cmd];
}
#pragma luggage device delegate
-(void)onDeviceDiscovered:(CBPeripheral *)device rssi:(NSInteger)rssi;
{
    NSLog(@"App: discovered\n");
    if ([device.name isEqualToString:[NSString stringWithFormat:@"Luggage%@",self.account.deviceId]]) {
        _foundDev = device;
        [self performSelector:@selector(connectToDevice) withObject:self afterDelay:1];
        NSLog(@"ViewController: %@", device.name);
        
    }
}
-(void)connectToDevice
{
    [_luggageDevice BLEConectTo:_foundDev];
}
-(void)onLuggageDeviceConected
{
    NSLog(@"ViewController: connected\n");
    //Will cause to read battery when connected
    readBatteryCounter = UPDATE_BATTERY_COUNTER;
    _updateRssiTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onUpdateRssi) userInfo:nil repeats:YES];
    
}

-(void)onUpdateRssi
{
    [_foundDev readRSSI];
    if(readBatteryCounter++ == UPDATE_BATTERY_COUNTER)
    {
        readBatteryCounter = 0;
        [self sendBLECommad:@"AT+GTBAT\r"];
    }
}

-(void)onRssiRead:(NSNumber*)rssi
{
    NSLog(@"%@\n", rssi);
    
    [self setValue:[NSString stringWithFormat:@"%f",  powf(10, (-63-[rssi floatValue])/10.0/4.0)] forKey:@"distance"];
}
-(void)onNtfCharateristicFound
{
    NSLog(@"ViewController: ntf character found\n");
}

-(void)onWriteCharateristicFound
{
    NSLog(@"ViewController: write character found\n");
}

-(void)onLuggageNtfChar:(NSString *)recData
{
    NSLog(@"ViewController: receive %@", recData);
    if ([getATCmd(recData) isEqualToString:@"AT+WT"]) {
        [self setValue:getATContent(recData) forKey:@"weight"];
    }
    if ([getATCmd(recData) isEqualToString:@"AT+BAT"]) {
        [self setValue:getATContent(recData) forKey:@"battery"];
    }
    if ([getATCmd(recData) isEqualToString:@"AT+FINGERREG"]) {
        [self setValue:getATContent(recData) forKey:@"FINGERREG"];
        
    }
    if ([getATCmd(recData) isEqualToString:@"AT+FINGERDEL"]) {
        [self setValue:getATContent(recData) forKey:@"FINGERDEL"];
        
    }

    
}

//distance = pow(10, (rssi-49)/10*4.0)
-(void)onSubscribeDone
{
    //[self performSelector:@selector(sendChar) withObject:self afterDelay:1];
#if 0
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Connected" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
#endif
    
}

-(void)onLuggageDevicePowerOn
{
    _bleState = true;
}

-(void)onLuggageDevicePowerOff
{
    _bleState = false;
}

-(void)onLuggageDeviceDissconnected
{
    NSLog(@"ViewController: disconnected\n");
    [_updateRssiTimer invalidate];
    _updateRssiTimer = nil;
    readBatteryCounter = 0;
    if (_bleState && _isDeviceBonded) {
        [self connectToDevice];
    }
}



-(NSString *) stringFromDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        
        // zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
        // [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

-(NSDate *) getDateFromString:(NSString *)string
{
    static NSDateFormatter *dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    
    NSDate *tm = [dateFormatter dateFromString:string];
    return tm;
}

-(void)pushLocalNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置1秒之后
    NSDate *pushDate = [NSDate date];
    
    NSString *destDateString = [self stringFromDate:pushDate];
    
    NSDate *pushDate1 =[self getDateFromString:destDateString];
    
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate1;
        // 设置时区
        notification.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        // 设置重复间隔
        notification.repeatInterval = 0;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = @"Attention! \nToo far away from the luggage";
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
        
    }
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

-(void)cancleLocalNotification
{
    // 获得 UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    //声明本地通知对象
    UILocalNotification *localNotification;
    if (localArray) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key"];
                if ([inKey isEqualToString:@"KEY"]) {
                    if (localNotification){
                        localNotification = nil;
                    }
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (!localNotification) {
            //不存在初始化
            localNotification = [[UILocalNotification alloc] init];
        }
        
        if (localNotification) {
            //不推送 取消推送
            [app cancelLocalNotification:localNotification];
            return;
        }
    }
}


NSString * getATCmd(NSString *str)
{
    NSRange fingerSuccessRange = [str rangeOfString:@"FINGERREG success"];
    if (fingerSuccessRange.location == NSNotFound)
    {
        NSRange end = [str rangeOfString:@"="];
        NSString *string = [str substringWithRange:NSMakeRange(0, end.location)];
        return string;
    }
    
    if (fingerSuccessRange.length > 0)
    {
        return @"AT+FINGERREG";
    }
    
    return @"";
}

NSString * getATContent(NSString *str)
{
    
    NSRange fingerSuccessRange = [str rangeOfString:@"FINGERREG success"];
    if (fingerSuccessRange.location == NSNotFound)
    {
        NSRange start = [str rangeOfString:@"="];
        NSRange end = [str rangeOfString:@"\r"];
        NSString *string = [str substringWithRange:NSMakeRange(start.location+1, end.location -start.location-1)];
        return string;
    }
    
    if (fingerSuccessRange.length > 0)
    {
        return @"OK";
    }
    
    return @"";
}


-(void)jumpToMainAfterLogin
{
    [self registerDeviceToken:_deviceToken];
    _window.rootViewController = _mainVC;
}

-(void)jumpToLoginVC
{
    _window.rootViewController = _loginVC;
}

NSString * stringFromDate(NSDate *date)
{
    static NSDateFormatter *dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        
        // zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
        // [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}



static double a = 6378245.0;
static double ee = 0.00669342162296594323;

CLLocationCoordinate2D  transformFromWGSToGCJ(CLLocationCoordinate2D wgLoc) {
    
    //如果在国外，则默认不进行转换
    if (outOfChina(wgLoc.latitude, wgLoc.longitude)) {
        return wgLoc;
    }
    double dLat = transformLat(wgLoc.longitude - 105.0,
                               wgLoc.latitude - 35.0);
    double dLon = transformLon(wgLoc.longitude - 105.0,
                               wgLoc.latitude - 35.0);
    double radLat = wgLoc.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0)/ ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    
    wgLoc.latitude +=dLat;
    wgLoc.longitude += dLon;
    return wgLoc;
}

static double transformLat(double x, double y) {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y
    + 0.2 * sqrt(x > 0 ? x : -x);
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x
                                                                 * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0
                                                           * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y
                                                                  * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

 static double transformLon(double x, double y) {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1
    * sqrt(x > 0 ? x : -x);
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x
                                                                 * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0
                                                           * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x
                                                                    / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

 static bool outOfChina(double lat, double lon) {
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

-(void)proximityChange:(NSNotificationCenter *)notification
{
    //NSArray *bk_colors = [NSArray arrayWithObjects:[UIColor greenColor],[UIColor orangeColor],[UIColor blueColor],[UIColor lightGrayColor], nil];
    
    if([UIDevice currentDevice].proximityState == YES)
    {
        //self.window.rootViewController.view.backgroundColor = [bk_colors objectAtIndex:arc4random()%4];
        NSLog(@"Near");
    }
    else
    {
        NSLog(@"Far");
    }
}
@end
