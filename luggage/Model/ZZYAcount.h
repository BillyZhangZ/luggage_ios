//
//  ZZYUser.h
//  luggage
//
//  Created by 张志阳 on 11/30/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZYAcount : NSObject
@property (strong, nonatomic)  NSString *userName;
@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString *remotePhoneNumber;
@property (strong, nonatomic) NSString *localPhoneNumber;
@property (strong, nonatomic) NSString *deviceMac;
@property NSInteger age;
@property NSInteger sex;

//-(BOOL)storeCurrentAccountInfo:(NSString *)accountName userId:(NSString *)userId;

@end
