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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app addObserver:self forKeyPath:@"FINGERREG" options:NSKeyValueObservingOptionNew context:nil];
    [app addObserver:self forKeyPath:@"FINGERDEL" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app removeObserver:self forKeyPath:@"FINGERREG"];
    [app removeObserver:self forKeyPath:@"FINGERDEL"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Add Fingerprint        (8/16)";
    }
    else
        cell.textLabel.text = @"Delete Fingerprint     (8/16)";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12];
    
    //cell.imageView.image = [UIImage imageNamed:@"user.png"];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    if (indexPath.row == 0) {
        //send add fingerprint
        [app sendBLECommad:@"AT+FINGERREG\r"];
#if 1
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
#if 1
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



- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
