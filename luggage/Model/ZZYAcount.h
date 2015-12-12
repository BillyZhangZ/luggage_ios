//
//  ZZYUser.h
//  luggage
//
//  Created by 张志阳 on 11/30/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZYAcount : NSObject
@property NSString *userName;
@property NSInteger userId;
@property NSString *phoneNumber;
@property NSInteger age;
@property NSInteger sex;

-(BOOL)storeCurrentAccountInfo:(NSString *)accountName userId:(NSString *)userId;

@end
