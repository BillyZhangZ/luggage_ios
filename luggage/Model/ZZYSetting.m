//
//  ZZYSetting.m
//  luggage
//
//  Created by 张志阳 on 4/12/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import "ZZYSetting.h"

@implementation ZZYSetting
- (instancetype) init
{
    self = [super init];
    
    if(self != nil)
    {
        NSDictionary *setting = [self loadCurrentSettingInfo];
        if (setting == nil) {
            return self;
        }
        _alertSetting = [setting objectForKey:@"alert"];
        _notifySetting = [setting objectForKey:@"notify"];
        NSLog(@"login with user: %@\t id: %@\n",_alertSetting, _notifySetting);
    }
    return self;
}

-(void)setAlertSetting:(NSString*)alertSetting
{
    NSLog(@"set alert setting");
    _alertSetting = alertSetting;
    [self storeItemToDisk:@"alert" value:_alertSetting];
}

-(void)setNotifySetting:(NSString *)notifySetting
{
    NSLog(@"set notify setting");
    _notifySetting = notifySetting;
    [self storeItemToDisk:@"notify" value:_notifySetting];
}

-(void)storeItemToDisk:(NSString *)key value:(NSString *)value
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
        // NSLog(@"path = %@",path);
    NSString *plistPath=[path stringByAppendingPathComponent:@"Setting.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath: plistPath contents:nil attributes:nil];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"alert",@"0",@"notify",nil];
        [dic writeToFile:plistPath atomically:YES];
    }
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
    [data setObject:value forKey:key];
        
    NSLog(@"update setting info:\n%@", data);
        
        //得到完整的文件名
    NSString *filename=[path stringByAppendingPathComponent:@"Setting.plist"];
        //输入写入
    [data writeToFile:filename atomically:YES];
}
     
-(NSDictionary *)loadCurrentSettingInfo
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"Setting.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"loading setting info:\n%@", data);
    
    return data;
}
@end
