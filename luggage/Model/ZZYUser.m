//
//  ZZYUser.m
//  luggage
//
//  Created by 张志阳 on 11/30/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import "ZZYUser.h"

@implementation ZZYUser
- (instancetype) init:(BOOL)isGuest name:(NSString *)userName userID:(NSUInteger)userID
{
    self = [super init];
    
    if(self != nil)
    {
        _userId = userID;
        _userName = userName;
    }
    
    return self;
}
@end
