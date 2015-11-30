//
//  AppDelegate.m
//  luggage
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LocateViewController.h"
#import "ZZYSMSLoginViewController.h"
#import "WXApi.h"
#import <SMS_SDK/SMS_SDK.h>
#import <MAMapKit/MAMapKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()<WXApiDelegate>
{
    ViewController * _mainVC;
    ZZYSMSLoginViewController *_loginVC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _mainVC = [[ViewController alloc] init];
    _loginVC = [[ZZYSMSLoginViewController alloc]init];
    [WXApi registerApp:@"wx9d60ab46bfa2d903" withDescription:@"luggage"];
    [SMS_SDK registerApp:@"cdabbcf0f504"  withSecret:@"ccbe1fa6a1f8f17075f03951b29d1618"];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _loginVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

-(void)jumpToMainVC
{
    _window.rootViewController = _mainVC;
}

@end
