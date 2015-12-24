//
//  MainViewController.h
//  luggage
//
//  Created by 张志阳 on 11/29/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *locateButton;

@property (weak, nonatomic) IBOutlet UIButton *lostButton;
@property (weak, nonatomic) IBOutlet UIButton *addDeviceButton;
@property (weak, nonatomic) IBOutlet UIButton *bleUnlockButton;
@property (weak, nonatomic) IBOutlet UIButton *smsUnlockButton;


@property (weak, nonatomic) IBOutlet UINavigationBar *navigatorBar;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@end
