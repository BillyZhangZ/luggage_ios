//
//  LCommonTools.m
//  luggage
//
//  Created by 余海平 on 16/9/19.
//  Copyright © 2016年 张志阳. All rights reserved.
//

#import "LCommonTools.h"

@implementation LCommonTools

+ (BOOL)isBlankString:(NSString *)string
{
    
    
    if (string == nil || string == NULL) {
        
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    return NO;
}


@end
