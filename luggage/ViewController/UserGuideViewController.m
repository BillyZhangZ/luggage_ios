//
//  UserGuideViewController.m
//  luggage
//
//  Created by 张志阳 on 3/2/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import "UserGuideViewController.h"
#import "UserGuideView.h"
#import "AppDelegate.h"
@interface UserGuideViewController () <UserGuideViewDelegate>
@property UserGuideView *introView;

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_screen_viewed"]) {
        self.introView = [[UserGuideView alloc] initWithFrame:self.view.frame];
        
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor colorWithWhite:0.149 alpha:1.000];
        [self.view addSubview:self.introView];
    }
}

#pragma mark - UserGuideViewDelegate Methods

-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    //    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app setViewControllerAfterGuide];
    }];
}


@end