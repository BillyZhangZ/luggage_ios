//
//  XJUserHomeViewController.m
//  Pao123
//
//  Created by 张志阳 on 15/7/2.
//  Copyright (c) 2015年 XingJian Software. All rights reserved.
//

#import "ZZYUserVC.h"
#import "AppDelegate.h"
#import "basicInfoCel.h"
@interface ZZYUserVC ()<UIGestureRecognizerDelegate>
{
    BOOL cellRegistered;
}

//@property (nonatomic, weak) XJAccountManager *accountManager;
//@property (nonatomic, weak) XJAccount *myAccount;
@end
@implementation ZZYUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];
    UIScreenEdgePanGestureRecognizer * screenEdgePan
    = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    screenEdgePan.delegate = self;
    screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];

    cellRegistered = false;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.view.userInteractionEnabled = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    cellRegistered = false;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"home vc dealloc");
}


#pragma mark - disable landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor: [UIColor clearColor]];
    switch (indexPath.section) {
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!cellRegistered) {
        UINib *nib = [UINib nibWithNibName:@"basicInfoCel" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"basicInfoCellIndentifier"];
        cellRegistered = true;
    }
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    basicInfoCel  *cell = [tableView dequeueReusableCellWithIdentifier:@"basicInfoCellIndentifier"];
    if(cell == nil)
        cell = [[basicInfoCel alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"basicInfoCellIndentifier"];

    switch (indexPath.section) {
        case 0:
            cell.name.text = @"Name";
            cell.value.text = [NSString stringWithFormat:@"%@", app.account.userName];
            cell.unit.text = @"";
            break;
        case 1:
            cell.name.text = @"Email";
            cell.value.text = [NSString stringWithFormat:@"%@", app.account.email];
            cell.unit.text = @"";
            break;
        case 2:
            cell.name.text = @"Phone";
            cell.value.text = [NSString stringWithFormat:@"%@", app.account.localPhoneNumber];
            cell.unit.text = @"";
            break;
               default:
            break;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle  = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    CGRect viewFrame = CGRectMake(0, 0, tableView.bounds.size.width, 30);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    view.backgroundColor= [UIColor colorWithRed:31/255.0 green:31/255.0 blue:34/255.0 alpha:0.4];
    return view;
    //return label;
}


- (IBAction)backButtonClicked:(id)sender {
    //保存
#if 0
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app showMenu];
#else
    [self dismissViewControllerAnimated:YES completion:nil];
#endif
}

- (IBAction)logoutButtonClicked:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    app.account.userName = @"";
    app.account.userId = @"";
    app.account.localPhoneNumber = @"";
    app.account.remotePhoneNumber = @"";
    app.account.deviceMac = @"";
    app.account.email = @"";
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [app jumpToLoginVC];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 300;
}

- (void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state)
    {
        //根据被触摸手势的view计算得出坐标值
        CGPoint translation = [gesture translationInView:gesture.view];
        NSLog(@"%@", NSStringFromCGPoint(translation));
    }
    else
    {
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        [app showMenu];
    }
}
@end
