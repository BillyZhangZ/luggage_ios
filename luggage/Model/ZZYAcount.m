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
        NSString *accountName = [accountInfo valueForKey:@"name"];
        NSString *accountId = [accountInfo valueForKey:@"id"];
        if ([accountName isEqual: @""] || [accountId isEqual: @""]) {
            return self;
        }
        _userId = [accountId integerValue];
        _phoneNumber = accountName;
    }
    
    return self;
}

-(NSDictionary *)loadCurrentAccountInfo
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"Account.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    return data;
}

-(BOOL)storeCurrentAccountInfo:(NSString *)accountName userId:(NSString *)userId
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    // NSLog(@"path = %@",path);
    NSString *plistPath=[path stringByAppendingPathComponent:@"Account.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath: plistPath contents:nil attributes:nil];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"id",@"0",@"name",nil];
        [dic writeToFile:plistPath atomically:YES];
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [data setObject:accountName forKey:@"name"];
    [data setObject:userId forKey:@"id"];
    
    //得到完整的文件名
    NSString *filename=[path stringByAppendingPathComponent:@"Account.plist"];
    //输入写入
    [data writeToFile:filename atomically:YES];
    
    //NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    //NSLog(@"%@", data1);
    
    
    return true;
}
@end
