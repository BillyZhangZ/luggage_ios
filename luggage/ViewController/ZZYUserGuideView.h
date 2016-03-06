//
//  UserGuideViewController.h
//  luggage
//
//  Created by 张志阳 on 3/2/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserGuideViewDelegate <NSObject>

-(void)onDoneButtonPressed;
@end

@interface ZZYUserGuideView : UIView
@property id<UserGuideViewDelegate> delegate;
@end
