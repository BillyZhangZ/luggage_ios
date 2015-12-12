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
    
    NSArray *_cmds;
    NSInteger _cmdIndex;
}
@end

@implementation BLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _luggageDevice = [[LuggageDevice alloc]init:self];
    _foundDevices = [[NSMutableArray alloc]init];
    
    _cmds = [[NSArray alloc]initWithObjects:SET_NAME,GET_NAME, GET_BAT,GET_DEV_INFO, GET_MODE, GET_SIM_NUMBER, GET_SW_VER,GET_WEIGHT,nil];
    _cmdIndex = 0;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else return [_foundDevices count];
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
    if (indexPath.section == 1) {
        [_luggageDevice BLEConectTo:(CBPeripheral *)[[_foundDevices objectAtIndex:indexPath.row] valueForKey:@"device"]];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect viewFrame = CGRectMake(0, 0, tableView.bounds.size.width, 30);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    view.backgroundColor= [UIColor colorWithRed:31/255.0 green:31/255.0 blue:34/255.0 alpha:0.4];
    CGRect LabelFrame = CGRectMake(10, 0, 150, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:LabelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    if (section == 0) {
        
        label.text = @"已绑定设备";
    }
    else
    {
        label.text = @"新设备";
    }
    return view;
}

#pragma luggage device delegate
-(void)onDeviceDiscovered:(CBPeripheral *)device rssi:(NSInteger)rssi;
{
    for (NSDictionary *dic in _foundDevices) {
        if ([device.name isEqualToString:[dic valueForKey:@"name"]]) {
            return;
        }
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:device.name, @"name", device, @"device", [NSString stringWithFormat:@"%d",rssi],@"rssi", nil];
    [_foundDevices addObject:dic];
    
    [self.tableView reloadData];
    
}
-(void)onLuggageDeviceConected
{
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"ios:connnected\n"];
    self.logText.text  = log;
}

-(void)onNtfCharateristicFound
{
    
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"ios:found ntf char\n"];
    self.logText.text  = log;
    
}

-(void)onWriteCharateristicFound
{
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"ios:found write char\n"];
    self.logText.text  = log;
}

-(void)sendChar
{
   
    if (_cmdIndex >= [_cmds count]) {
        return;
    }
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"ios:"];
    [log appendString:[_cmds objectAtIndex:_cmdIndex]];
    self.logText.text  = log;
    [_luggageDevice LuggageWriteChar:[_cmds objectAtIndex:_cmdIndex++] ];
    
  
}
-(void)onSubscribeDone
{
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"ios:set ntf ok\n"];
    self.logText.text  = log;
    [self performSelector:@selector(sendChar) withObject:self afterDelay:1];
}
-(void)onLuggageDeviceDissconnected
{
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"ios:disconnected\n"];
    self.logText.text  = log;

}

-(void)onLuggageNtfChar:(NSString *)recData
{
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"linkit:"];
    [log appendString:recData];
    self.logText.text  = log;
    [self sendChar];
    
}


- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
