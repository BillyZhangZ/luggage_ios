//
//  ZZYUser.m
//  luggage
//
//  Created by 张志阳 on 11/30/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import "ZZYAcount.h"

@implementation ZZYAcount
- (instancetype) init
{
    self = [super init];
    
    if(self != nil)
    {
        NSDictionary *accountInfo = [self loadCurrentAccountInfo];
        if (accountInfo == nil) {
            return self;
        }
        NSString *phoneNumber = [accountInfo valueForKey:@"localPhoneNumber"];
        NSString *accountId = [accountInfo valueForKey:@"id"];
        if ([phoneNumber isEqual: @""] || [accountId isEqual: @""]) {
            return self;
        }
        _userId = accountId;
        _localPhoneNumber = phoneNumber;
        _remotePhoneNumber = [accountInfo objectForKey:@"remotePhoneNumber"];
        _email = [accountInfo objectForKey:@"email"];
        _userName = [accountInfo objectForKey:@"name"];
        _deviceMac = [accountInfo objectForKey:@"deviceId"];
        NSLog(@"login with user: %@\t id: %@\n",_localPhoneNumber, _userId);
        
    }
    return self;
}

-(void)setRemotePhoneNumber:(NSString *)remotePhoneNumber
{
    NSLog(@"set remote phone number");
    _remotePhoneNumber = remotePhoneNumber;
    [self storeItemToDisk:@"remotePhoneNumber" value:remotePhoneNumber];
}

-(void)setLocalPhoneNumber:(NSString *)localPhoneNumber
{
    _localPhoneNumber = localPhoneNumber;
    NSLog(@"set local phone number");
    [self storeItemToDisk:@"localPhoneNumber" value:localPhoneNumber];
}

-(void)setUserName:(NSString *)userName
{
    _userName = userName;
    [self storeItemToDisk:@"name" value:userName];
}
-(void)setDeviceMac:(NSString *)deviceMac
{
    _deviceMac = deviceMac;
    NSLog(@"set  device mac");
    [self storeItemToDisk:@"deviceId" value:deviceMac];
}

-(void)setUserId:(NSString *)userId
{
    _userId = userId;
    NSLog(@"set user id");
    [self storeItemToDisk:@"id" value:userId];
}

-(void)setEmail:(NSString *)email
{
    _email = email;
    [self storeItemToDisk:@"email" value:_email];
}
-(void)dealloc
{

}
-(NSDictionary *)loadCurrentAccountInfo
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"Account.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"loading user info:\n%@", data);

    return data;
}

-(void)storeItemToDisk:(NSString *)key value:(NSString *)value
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    // NSLog(@"path = %@",path);
    NSString *plistPath=[path stringByAppendingPathComponent:@"Account.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath: plistPath contents:nil attributes:nil];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"id",@"",@"email",@"",@"name",@"0",@"localPhoneNumber",@"0", @"remotePhoneNumber", @"0", @"deviceId",nil];
        [dic writeToFile:plistPath atomically:YES];
    }
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [data setObject:value forKey:key];
    
    NSLog(@"update user ifo:\n%@", data);
    
    //得到完整的文件名
    NSString *filename=[path stringByAppendingPathComponent:@"Account.plist"];
    //输入写入
    [data writeToFile:filename atomically:YES];
    
}
@end
