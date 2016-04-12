//
//  ZZYFeedbackVC.m
//  luggage
//
//  Created by 张志阳 on 4/12/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import "ZZYFeedbackVC.h"

@interface ZZYFeedbackVC ()

@end

@implementation ZZYFeedbackVC
-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
