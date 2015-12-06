//
//  BLEViewController.m
//  luggage
//
//  Created by 张志阳 on 12/6/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import "BLEViewController.h"
#import "BLEDevice.h"
@interface BLEViewController ()<UITableViewDataSource,UITableViewDelegate, LuggageDelegate>
{
    LuggageDevice *_luggageDevice;
    NSMutableArray *_foundDevices;
}
@end

@implementation BLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _luggageDevice = [[LuggageDevice alloc]init:self];
    _foundDevices = [[NSMutableArray alloc]init];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_foundDevices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuTableCell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"menuTableCell"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [[_foundDevices objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.detailTextLabel.text = [[_foundDevices objectAtIndex:indexPath.row] valueForKey:@"rssi"];
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
    
}


#pragma luggage device delegate
-(void)onDeviceDiscovered:(NSString *)deviceName rssi:(NSInteger)rssi
{
    for (NSDictionary *dic in _foundDevices) {
        if ([deviceName isEqualToString:[dic valueForKey:@"name"]]) {
            return;
        }
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:deviceName, @"name", [NSString stringWithFormat:@"%d",rssi],@"rssi", nil];
    [_foundDevices addObject:dic];
    
    [self.tableView reloadData];
    
}
-(void)onLuggageDeviceConected
{
#if 0
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"luggage已连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

-(void)onLuggageDeviceDissconnected
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"luggage已断开连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)onLuggageNtfChar:(NSString *)recData
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到数据" message:recData preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
