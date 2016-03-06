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
#import <MAMapKit/MAMapKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZZYBookTicketVC.h"
#import "ZZYFootprintVC.h"
#import "ZZYWebsiteVC.h"
#import "ZZYSettingsVC.h"
#import "ZZYUserVC.h"
#import "ZZYUserGuideVC.h"
@interface AppDelegate ()<WXApiDelegate>
{
    ZZYMainVC * _mainVC;
    ZZYSMSLoginVC *_loginVC;
    ZZYMenuView *_menuView;
    
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _mainVC = [[ZZYMainVC alloc] init];
    _loginVC = [[ZZYSMSLoginVC alloc]init];
    _account = [[ZZYAcount alloc]init];
    
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
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        ZZYUserGuideVC *userGuideViewController = [[ZZYUserGuideVC alloc] init];
        self.window.rootViewController = userGuideViewController;
        self.window.backgroundColor = [UIColor whiteColor];

    }
    else
    {
        NSLog(@"不是第一次启动");
        if (_account.localPhoneNumber == nil) {
            self.window.rootViewController = _loginVC;
        }
        else
        {
            self.window.rootViewController = _mainVC;
        }
    }
    
    [self.window makeKeyAndVisible];

    return YES;
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到通知" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}

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
        _menuView.lblName.text = @"用户名";
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

- (void) hideMenu
{
    CGRect rc = _menuView.frame;
    rc.origin.x = - lo_menu_width * rate_pixel_to_point;
    _menuView.frame = rc;
    [_menuView removeFromSuperview];
}

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
    else if([itemName compare:@"足迹"] == NSOrderedSame)
    {
        //_window.rootViewController = _mainVC;
        ZZYFootprintVC *vc = [[ZZYFootprintVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    else if([itemName compare:@"航班信息"] == NSOrderedSame)
    {
       // _window.rootViewController = _histVC;
        ZZYBookTicketVC *vc = [[ZZYBookTicketVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    else if([itemName compare:@"新品上市"] == NSOrderedSame)
    {
        ZZYWebsiteVC *vc = [[ZZYWebsiteVC alloc]init];
        [_window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
    else if([itemName compare:@"预留3"] == NSOrderedSame)
    {
        
    }
    else if([itemName compare:@"预留2"] == NSOrderedSame)
    {
        
    }
    else if([itemName compare:@"设置"] == NSOrderedSame)
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

NSString * getATCmd(NSString *str)
{
    
    NSRange end = [str rangeOfString:@"="];
    NSString *string = [str substringWithRange:NSMakeRange(0, end.location)];
    return string;
}

NSString * getATContent(NSString *str)
{
    
    NSRange start = [str rangeOfString:@"="];
    NSRange end = [str rangeOfString:@"\r"];
    NSString *string = [str substringWithRange:NSMakeRange(start.location+1, end.location -start.location-1)];
    return string;
}


-(void)jumpToMainVC
{
    _window.rootViewController = _mainVC;
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


@end
