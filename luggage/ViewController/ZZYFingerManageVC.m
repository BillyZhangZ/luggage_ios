//
//  ZZYFingerManageVC.m
//  luggage
//
//  Created by 张志阳 on 4/11/16.
//  Copyright © 2016 张志阳. All rights reserved.
//

#import "ZZYFingerManageVC.h"
#import "AppDelegate.h"
@interface ZZYFingerManageVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZZYFingerManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    _table.tableFooterView = footView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app addObserver:self forKeyPath:@"FINGERREG" options:NSKeyValueObservingOptionNew context:nil];
    [app addObserver:self forKeyPath:@"FINGERDEL" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app removeObserver:self forKeyPath:@"FINGERREG"];
    [app removeObserver:self forKeyPath:@"FINGERDEL"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Add Fingerprint";
    }
    else
        cell.textLabel.text = @"Delete Fingerprint";
    cell.textLabel.textColor  = [UIColor colorWithRed:29/255.0 green:176/255.0 blue:237/255.0 alpha:1.0];;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12];
    
    //cell.imageView.image = [UIImage imageNamed:@"user.png"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (indexPath.row == 0) {
        //send add fingerprint
        [app sendBLECommad:@"AT+FINGERREG\r"];
#if 0
        NSString *title = [NSString stringWithFormat:@"Add fingerprint OK \n9/16"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
#endif

    }
    else
    {
        //send del fingerprint
        [app sendBLECommad:@"AT+FINGERDEL\r"];
#if 0
        NSString *title = [NSString stringWithFormat:@"Delete fingerprint OK \n7/16"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
#endif
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"FINGERREG"])
    {
        NSString *ret = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"add finger is changed! new=%@", ret);
        NSString *title = [NSString stringWithFormat:@"Add fingerprint %@",[ret integerValue] != -1?@"OK":@"Failed"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([keyPath isEqualToString:@"FINGERDEL"])
    {
        NSString *ret = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"del finger is changed! new=%@", ret);
        NSString *title = [NSString stringWithFormat:@"Delete fingerprint %@",[ret integerValue] != -1?@"OK":@"Failed"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
