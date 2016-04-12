//
//  XJBaseNavVC.m
//  Pao123
//
//  Created by Zhenyong Chen on 6/13/15.
//  Copyright (c) 2015 XingJian Software. All rights reserved.
//

#import "config.h"
#import "AppDelegate.h"
#import "ZZYBaseNavVC.h"

@interface ZZYBaseNavVC ()
{
    // title bar
    UINavigationBar *_navBar;
}

@property (nonatomic) CGRect clientRect;
@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;

@end

@implementation ZZYBaseNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self constructView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setVcTitle:(NSString *)vcTitle
{
    _vcTitle = vcTitle;
    
    if(_navBar == nil || _navBar.items == nil || _navBar.items.count == 0)
        return;

    //UINavigationItem *navItem = _navBar.items.firstObject;
    //navItem.title = vcTitle;
}

- (void) constructView
{
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    CGRect rcApp = [[UIScreen mainScreen] bounds];
    int statusBarHeight = rcApp.origin.y;
    CGRect rc;

    self.view.backgroundColor = DEFBKCOLOR;

    //----------------------------------------------------------------------------
    // configure status bar
    //----------------------------------------------------------------------------
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rcScreen.size.width, statusBarHeight)];
    statusBarView.backgroundColor = STATUSBARTINTCOLOR;
    [self.view addSubview:statusBarView];

    //----------------------------------------------------------------------------
    // add navigation bar and configure it
    //----------------------------------------------------------------------------
    rc = rcApp;
    rc.origin.y = 20;
    rc.size.height = TITLEBARHEIGHT;
    _navBar = [[UINavigationBar alloc] initWithFrame:rc];
    //_navBar.barTintColor = [UIColor clearColor];
//    _navBar.translucent = NO;
    [_navBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];;
    [_navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:NAVIGATIONBAR_TITLE_FONT_NAME size:NAVIGATIONBAR_TITLE_FONT_SIZE], NSFontAttributeName, nil]];
    
    UINavigationItem * navItem = [[UINavigationItem alloc] initWithTitle:self.vcTitle];
    [_navBar pushNavigationItem:navItem animated:NO];
    [self.view addSubview: _navBar];

    // create UIBarButtons
    if(self.leftButtonImage != nil)
    {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.frame = CGRectMake(0, 0, NAVIGATIONBAR_LEFT_ICON_SIZE, NAVIGATIONBAR_LEFT_ICON_SIZE);
        [self.leftButton setTitle:@"Back" forState:UIControlStateNormal];
        [self.leftButton setTintColor:[UIColor blueColor]];
        //[self.leftButton setBackgroundImage:[UIImage imageNamed:self.leftButtonImage] forState:UIControlStateNormal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
        [navItem setLeftBarButtonItem:item];
    }

    // set client area
    self.clientRect = CGRectMake(0, rc.origin.y + rc.size.height, rcScreen.size.width, rcScreen.size.height - rc.origin.y - rc.size.height);
}

//---------------------------------------------------------------------------------------------
// Only support portrait
//---------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
