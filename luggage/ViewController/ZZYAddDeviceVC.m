//
//  BLEViewController.m
//  luggage
//
//  Created by 张志阳 on 12/6/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import "ZZYAddDeviceVC.h"
#import "BLEDevice.h"
#import "AppDelegate.h"
enum BLE_OPERATION
{
    BLE_OPERATION_NONE,
    BLE_OPERATION_GET_LUGGAGE_NUMBER,
    BLE_OPERATION_SEND_LOCAL_PHONE_NUMBER,
    
};

@interface ZZYAddDeviceVC ()<UITableViewDataSource,UITableViewDelegate, LuggageDelegate>
{
    LuggageDevice *_luggageDevice;
    NSMutableArray *_foundDevices;
    
    
    enum BLE_OPERATION _opration;
}
@end

@implementation ZZYAddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _luggageDevice = [[LuggageDevice alloc]init:self];
    _foundDevices = [[NSMutableArray alloc]init];
    
    _opration = BLE_OPERATION_NONE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_luggageDevice BLEDisconnect];
    _luggageDevice = nil;
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
        
        label.text = @"Bonded Devices";
    }
    else
    {
        label.text = @"Unboned Devices";
    }
    return view;
}

-(void)getLuggagePhoneNumber
{
    [_luggageDevice LuggageWriteChar:@"AT+GTSIM\r"];
}

-(void)sendLocalPhoneNumber
{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    if (app.account.localPhoneNumber == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Login in" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    //FIX ME
    [_luggageDevice LuggageWriteChar: app.account.localPhoneNumber];
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


//distance = pow(10, (rssi-49)/10*4.0)
-(void)onSubscribeDone
{
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"ios:set ntf ok\n"];
    self.logText.text  = log;
    [self getLuggagePhoneNumber];
    _opration = BLE_OPERATION_GET_LUGGAGE_NUMBER;
}
-(void)onLuggageDeviceDissconnected
{
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"ios:disconnected\n"];
    self.logText.text  = log;
}

-(void)onRssiRead:(NSNumber *)rssi
{
    
}

-(void)onLuggageDevicePowerOn
{
}

-(void)onLuggageDevicePowerOff
{
}


-(void)onLuggageNtfChar:(NSString *)recData
{
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSLog(@"%@", getATCmd(recData));
    NSMutableString *log = [[NSMutableString alloc]initWithString:self.logText.text];
    [log appendString:@"linkit:"];
    [log appendString:recData];
    self.logText.text  = log;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Bond Success" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];

    switch (_opration) {
        case BLE_OPERATION_NONE:
            //error
            break;
        case BLE_OPERATION_GET_LUGGAGE_NUMBER:
            app.account.remotePhoneNumber = getATContent(recData);
           // [app.account setValue:getATContent(recData) forKey:@"remotePhoneNumber"];
            NSLog(@"%@",app.account.remotePhoneNumber);
            [self presentViewController:alert animated:YES completion:nil];

          //  [self sendLocalPhoneNumber];
           // _opration = BLE_OPERATION_SEND_LOCAL_PHONE_NUMBER;
            break;
        case BLE_OPERATION_SEND_LOCAL_PHONE_NUMBER:
            
            _opration = BLE_OPERATION_NONE;
            break;
        default:
            break;
    }
    _opration = BLE_OPERATION_NONE;
}


- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
