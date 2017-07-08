//
//  LMenuViewController.m
//  luggage
//
//  Created by 余海平 on 16/9/19.
//  Copyright © 2016年 张志阳. All rights reserved.
//

#import "LMenuViewController.h"
#import "AppDelegate.h"

#import "ZZYFootprintVC.h"
#import "ZZYWebsiteVC.h"
#import "ZZYSettingsVC.h"
#import "ZZYUserVC.h"
#import "ZZYFingerManageVC.h"
#import "ZZYBondDeviceIdVC.h"
#import "ZZYBookTicketVC.h"
#import "ZZYAcount.h"
#import "ZZYUserVC.h"

@interface LMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView   *_menuTabelView;
    NSMutableArray  *_dataArray;

}
@end

@implementation LMenuViewController

static NSString  *cellIdentifer = @"menuCellIdentifer";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];

    self.view.backgroundColor = [UIColor colorWithRed:29/255.0 green:176/255.0 blue:237/255.0 alpha:1.0];

    _dataArray = [[NSMutableArray alloc]init];
    
    
    [_dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Footprint",@"text",[UIImage imageNamed:@"footPrint.png"],@"image", nil]];

    [_dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Flight",@"text",[UIImage imageNamed:@"Flight.png"],@"image", nil]];
    
    [_dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Products",@"text",[UIImage imageNamed:@"Products.png"],@"image", nil]];

    [_dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Add Device",@"text",[UIImage imageNamed:@"addDevice.png"],@"image", nil]];
    
    [_dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Fingerprint",@"text", [UIImage imageNamed:@"finger.png"],@"image",nil]];
    
    [_dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Settings",@"text", [UIImage imageNamed:@"setting.png"],@"image",nil]];

   
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    
    UIButton *headBtn = [[UIButton alloc]init];
    [headBtn setImage:[UIImage imageNamed:@"avatar.png"] forState:UIControlStateNormal];
    [headBtn addTarget:self action:@selector(checkUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headBtn];
    [headBtn setTranslatesAutoresizingMaskIntoConstraints:NO];

    UILabel *userLabel = [[UILabel alloc]init];
    userLabel.lineBreakMode = NSLineBreakByCharWrapping;
    userLabel.numberOfLines = 0;
    userLabel.text = [[ZZYAcount alloc]init].userName;
    userLabel.textAlignment = NSTextAlignmentCenter;
    userLabel.textColor = [UIColor whiteColor];
    userLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:userLabel];
    userLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[headBtn(==85)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headBtn,userLabel)]];
    
    [headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[userLabel(>=0)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headBtn,userLabel)]];

    
    [headView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[headBtn(==85)]-10-[userLabel(>=15)]-(>=5)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(headBtn,userLabel)]];
    
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:headBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    
    _menuTabelView = [[UITableView alloc]init];
    _menuTabelView.backgroundColor = [UIColor clearColor];
    _menuTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTabelView.delegate = self;
    _menuTabelView.dataSource = self;
    [_menuTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifer];
    _menuTabelView.rowHeight = 50;
    _menuTabelView.tableHeaderView = headView;
    [self.view addSubview:_menuTabelView];
    _menuTabelView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *subDic = NSDictionaryOfVariableBindings(_menuTabelView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_menuTabelView(>=0)]-0-|" options:0 metrics:nil views:subDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_menuTabelView(>=0)]-0-|" options:0 metrics:nil views:subDic]];
    
}

- (void)checkUserInfo {


    ZZYUserVC  *userViewControl = [[ZZYUserVC alloc]init];
    userViewControl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userViewControl animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    cell.backgroundColor = [UIColor colorWithRed:29/255.0 green:176/255.0 blue:237/255.0 alpha:1.0];
    cell.imageView.image = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"image"];
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"text"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if(indexPath.row == 0)
    {
        ZZYFootprintVC *vc = [[ZZYFootprintVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 1)
    {
        ZZYBookTicketVC *vc = [[ZZYBookTicketVC alloc]init];
        vc.title = @"Flight";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if(indexPath.row == 2)
    {
        ZZYWebsiteVC *vc = [[ZZYWebsiteVC alloc]init];
        vc.title = @"Products";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if(indexPath.row == 3)
    {
        ZZYBondDeviceIdVC *vc = [[ZZYBondDeviceIdVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if(indexPath.row == 4)
    {
        ZZYFingerManageVC *vc = [[ZZYFingerManageVC alloc]init];
        vc.title = @"Fingerprint Management";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if(indexPath.row == 5)
    {
        ZZYSettingsVC *vc = [[ZZYSettingsVC alloc]init];
        vc.title = @"Settings";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

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

@end
