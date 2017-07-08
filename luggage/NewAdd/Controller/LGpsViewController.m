//
//  LGpsViewController.m
//  luggage
//
//  Created by 余海平 on 16/9/19.
//  Copyright © 2016年 张志阳. All rights reserved.
//

#import "LGpsViewController.h"
#import "config.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>

@interface LGpsViewController ()<MKMapViewDelegate,UIGestureRecognizerDelegate>
{
    MKMapView *_mapView;
    UIButton  *_currentLocationButton;
    UIButton  *_lockCompassDirectionButton;
    UIButton  *_mapModeButton;
    UILabel   *_searchingLabel;
    
    CLLocationDegrees _longtitude;
    CLLocationDegrees _latitude;
    
    CLLocationDegrees _cellbase_longtitude;
    CLLocationDegrees _cellbase_latitude;
    
    CLLocationDegrees _wifi_longtitude;
    CLLocationDegrees _wifi_latitude;
    
}
@end

@implementation LGpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];
    
    UIScreenEdgePanGestureRecognizer * screenEdgePan
    = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    screenEdgePan.delegate = self;
    screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];

    // Do any additional setup after loading the view.
}

#pragma mark - viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    //drop from mamap to mkmap
    // [MAMapServices sharedServices].apiKey = MAPAPIKEY;
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsTraffic= NO;
    
    //_mapView.language = MAMapLanguageEn;
    _mapView.showsUserLocation = NO;
    [_mapView setUserTrackingMode: MKUserTrackingModeNone animated:YES]; //地图跟着位置 移动
    
    //drop from mamap to mkmap
    //_mapView.pausesLocationUpdatesAutomatically = NO;
#if 0
    _mapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *mapTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onMapView:)];
    [_mapView addGestureRecognizer:mapTapGesture];
#endif
    _mapView.delegate = self;
#if 1
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(31.43715199999999,121.13612);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.04, 0.04);
    _mapView.region = MKCoordinateRegionMake(coord, span);
#endif
    //[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(zoomToAnnotations) userInfo:nil repeats:NO];
    
    
    //buttons
    _mapModeButton =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 180, CGRectGetHeight(self.view.bounds) - 80, 200, 40)];
    _mapModeButton.backgroundColor = [UIColor clearColor];
    [_mapModeButton setTitle:@"Use Pos1/Pos2" forState:UIControlStateNormal];
    [_mapModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _mapModeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_mapModeButton addTarget:self action:@selector(onMapButtonMode) forControlEvents:UIControlEventTouchUpInside];
    
    //_searchingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2 - 70, CGRectGetHeight(self.view.bounds) - 50, 200, 40)];
    _searchingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 60, CGRectGetWidth(self.view.bounds), 60)];
    [_searchingLabel setText:@" Searching Luggage "];
    
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self getLatestGpsLocation:[app.account.userId integerValue]];
    [self.view addSubview:_mapModeButton];
    [self.view addSubview:_mapView];
    [self.view bringSubviewToFront:_mapModeButton];
    [self.view addSubview:_searchingLabel];
}
#pragma mark -
#pragma mark - didUpdateUserLocation
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
#pragma mark -
#pragma mark - onMapButtonMode
- (void)onMapButtonMode
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self getLatestCellbaseLocation:[app.account.userId integerValue]];
    [self getLatestWifiLocation:[app.account.deviceId integerValue]];
}
#pragma mark -
#pragma mark - zoomToAnnotations
- (void)zoomToAnnotations:(NSString *)souce
{
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    //annotation.coordinate = CLLocationCoordinate2DMake(31.43715199999999, 121.13612);
    annotation.coordinate = CLLocationCoordinate2DMake(_latitude, _longtitude);
    
    annotation.title = souce;
    annotation.subtitle = @"";
    // 指定新的显示区域
    [_mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.04,0.04)) animated:YES];
    
    [_mapView addAnnotation:annotation];
    // 选中标注
    //[_mapView selectAnnotation:annotation animated:YES];
}

#pragma mark -
#pragma mark - zoomToAnnotations
- (void)zoomToWifiAnnotations:(NSString *)title Subtitle:(NSString *)subtitle
{
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    //annotation.coordinate = CLLocationCoordinate2DMake(31.43715199999999, 121.13612);
    annotation.coordinate = CLLocationCoordinate2DMake(_wifi_latitude, _wifi_longtitude);
    
    annotation.title = title;
    annotation.subtitle = subtitle;
    // 指定新的显示区域
    [_mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.04,0.04)) animated:YES];
    
    [_mapView addAnnotation:annotation];
    // 选中标注
    //[_mapView selectAnnotation:annotation animated:YES];
}
#pragma mark -
#pragma mark - didSelectAnnotationView
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annotation selected\n");
}

#if 0
-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
            annotationView.animatesDrop = YES;       //设置标注动画显示，默认为NO
            annotationView.draggable = NO;           //设置标注可以拖动，默认为NO
            annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];  //设置气泡右侧按钮
        }
        //annotationView.pinColor = [self.annotations indexOfObject:annotation];
        return annotationView;
    }
    return nil;
}
#endif

#pragma mark -
#pragma mark - handleGesture
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark -
#pragma mark - getLatestGpsLocation
- (void)getLatestGpsLocation:(NSInteger)userId
{
    
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_GET_GPS];
    [urlPost appendFormat:@"%lu",(unsigned long)userId];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setTimeoutInterval:10.0f];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict == nil || [dict objectForKey:@"userId"] == NULL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No records!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
                return ;
            }
            
            _latitude = [[dict valueForKey:@"latitude"] floatValue];
            _longtitude = [[dict valueForKey:@"longtitude"] floatValue];
            
            /* Calc time interval between the latest GPS record and current time */
            NSString *timeStamp = [dict valueForKey:@"timeStamp"];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [formatter setTimeZone:timeZone];
            
            NSString *currentTime = [formatter stringFromDate:[NSDate date]];
            
            NSDate *currentdate = [formatter dateFromString:currentTime];
            
            //NSString to NSDate
            NSDate *gpsdate = [formatter dateFromString:timeStamp];
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            
            unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            
            NSDateComponents *d = [cal components:unitFlags fromDate:gpsdate toDate:currentdate options:0];
            
            NSInteger intervalHours = [d day]*24 + [d hour];
            
            /* if interval bigger than 1hour, give some hint */
            if (intervalHours < 1) {
                NSLog(@"gps raw data %@", @"Searching!");
                [_searchingLabel setText:@""];
            }
            
            //38.8976763000,-77.0365298000
            CLLocationCoordinate2D coordWGS = CLLocationCoordinate2DMake(_latitude,_longtitude);
            CLLocationCoordinate2D coordGCJ = transformFromWGSToGCJ(coordWGS);
            _longtitude = coordGCJ.longitude;
            _latitude = coordGCJ.latitude;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self zoomToAnnotations:@"GPS location"];
            });
            NSLog(@"gps raw data %@",dict);
            
            
        }else{
            //出现错误；
            NSLog(@"错误信息：%@",error);
        }
        
    }];
    
    
    [dataTask resume];
    
}
#pragma mark -
#pragma mark - getLatestCellbaseLocation
- (void)getLatestCellbaseLocation:(NSInteger)userId
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_GET_CELLBASE];
    [urlPost appendFormat:@"%ld",[app.account.deviceId integerValue]];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setTimeoutInterval:10.0f];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict == nil || [dict objectForKey:@"deviceId"] == NULL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No records!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
                return ;
            }
            
            NSInteger mcc = [[dict valueForKey:@"mcc"] integerValue];
            NSInteger mnc = [[dict valueForKey:@"mnc"] integerValue];
            NSInteger lac = [[dict valueForKey:@"lac"] integerValue];
            NSInteger cid = [[dict valueForKey:@"cid"] integerValue];
            [self getGpsFromCellbase:mcc Mnc:mnc Lac:lac Cid:cid];
            
            NSLog(@"gps raw data %@",dict);
            
            
        }else{
            //出现错误；
            NSLog(@"error：%@",error);
        }
        
    }];
    
    [dataTask resume];
    
}
#pragma mark -
#pragma mark - getGpsFromCellbase
- (void)getGpsFromCellbase:(NSInteger)mcc Mnc:(NSInteger)mnc Lac:(NSInteger)lac Cid:(NSInteger)cid
{
    //fix me about url
    NSString *tmp = [NSString stringWithFormat:@"http://opencellid.org/cell/get?key=73027ce6-a49b-4b1d-b657-ddb0e5f45dd5&mcc=%ld&mnc=%ld&lac=%ld&cellid=%ld",mcc, mnc, (long)lac, (long)cid];
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:tmp];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setTimeoutInterval:10.0f];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        /*
         {"result":1,"format":"json","lac":10328,"cid":26997,"lat":23.13448,"lon":113.299602,"range":939,"hex":0,"src":0}
         */
        /*
         <rsp stat="ok">
         <cell lat="31.270260483333335" lon="121.57923918333334" mcc="460" mnc="0" lac="6340" cellid="33986" averageSignalStrength="-10" range="238" samples="6" changeable="1" radio="GSM"/>
         </rsp>
         */
        
        if (!error) {
            /* TODO: Parse XML using XML lib instead */
            NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"error：%@", xmlString);
            
            NSRange failRange = [xmlString rangeOfString:@"fail"];
            if (failRange.length > 0) {
                _latitude = _latitude + 0.0;
                _longtitude = _longtitude + 0.0;
                NSLog(@"error：-------");
            } else {
                NSString *lat = @"lat=\"";
                NSString *lon = @"\" lon=\"";
                NSString *mcc = @"\" mcc=\"";
                NSRange lat_range = [xmlString rangeOfString:lat];
                NSRange lon_range = [xmlString rangeOfString:lon];
                NSRange mcc_range = [xmlString rangeOfString:mcc];
                
                if ((lat_range.length > 0) && (lon_range.length > 0) && (mcc_range.length > 0))
                {
                
                    NSString *latSubString = [xmlString substringWithRange:NSMakeRange(lat_range.location + 5, lon_range.location - lat_range.location - 5)];
                    NSString *lonSubString = [xmlString substringWithRange:NSMakeRange(lon_range.location + 7, mcc_range.location - lon_range.location - 7)];
                
                    NSLog(@"lat：%@", latSubString);
                    NSLog(@"lon：%@", lonSubString);
                
                   _latitude = [latSubString floatValue];
                    _longtitude = [lonSubString floatValue];
                } else {
                    NSLog(@"cannot locate with cellbase");
                }
                
                if ([self isInChina:_latitude Lon:_longtitude] == 1) {
                    CLLocationCoordinate2D coordWGS = CLLocationCoordinate2DMake(_latitude,_longtitude);
                    CLLocationCoordinate2D coordGCJ = transformFromWGSToGCJ(coordWGS);
                    _longtitude = coordGCJ.longitude;
                    _latitude = coordGCJ.latitude;
                }
                
                [self zoomToAnnotations:@"Cellbase location"];
            }
        }else{
            //出现错误；
            NSLog(@"error：%@",error);
            _latitude = _latitude + 0.0;
            _longtitude = _longtitude + 0.0;
        }
        
    }];
    
    
    [dataTask resume];
}

#pragma mark -
#pragma mark - getLatestWifiLocation
-(void)getLatestWifiLocation:(NSInteger)deviceId
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_GET_WIFI];
    [urlPost appendFormat:@"%ld",(long)[app.account.deviceId integerValue]];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setTimeoutInterval:10.0f];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict == nil || [dict objectForKey:@"deviceId"] == NULL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No records!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
                return ;
            }
            
            NSString *bssid1 = [dict valueForKey:@"bssid1"];
            NSString *bssid2 = [dict valueForKey:@"bssid2"];
            
            [self getGpsFromWifi:bssid1 Bssid2:bssid2];
            
            NSLog(@"gps wifi data %@",dict);
            
            
        }else{
            //出现错误；
            NSLog(@"error：%@",error);
        }
        
    }];
    
    [dataTask resume];
    
}
#pragma mark -
#pragma mark - getGpsFromWifi
-(void)getGpsFromWifi:(NSString*)bssid1 Bssid2:(NSString*)bssid2
{
    NSDictionary *parameters = @{ @"token": @"96ae11c10ce4b8",
                                  @"wifi": @[ @{ @"bssid": bssid1, @"channel": @11, @"frequency": @2412, @"signal": @-51 }, @{ @"bssid":bssid2 } ],
                                  @"address": @1 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:
     [NSURL URLWithString:@"https://us2.unwiredlabs.com/v2/process.php"]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:1000.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSLog(@"Getting wifi data!" );
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   if (error) {
                       NSLog(@"%@", error);
                   } else {
                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                       NSLog(@"---------%@", httpResponse);
                       NSLog(@"-----xxxxx----%@", data);
                       
                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                       if (dict == nil || ![[dict objectForKey:@"status"]  isEqual: @"ok"]) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can not locate with wifi" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                               [alert addAction:okAction];
                               [self presentViewController:alert animated:YES completion:nil];
                           });
                           return ;
                       }
                       
                       float lat = [[dict valueForKey:@"lat"] floatValue];
                       float lon = [[dict valueForKey:@"lon"] floatValue];
                       
                       _wifi_latitude = lat;
                       _wifi_longtitude = lon;
                       
                       if ([self isInChina:lat Lon:lon] == 1) {
                           CLLocationCoordinate2D coordWGS = CLLocationCoordinate2DMake(_wifi_latitude,_wifi_longtitude);
                           CLLocationCoordinate2D coordGCJ = transformFromWGSToGCJ(coordWGS);
                           _wifi_longtitude = coordGCJ.longitude;
                           _wifi_latitude = coordGCJ.latitude;
                       }
                       
                       
                       NSInteger accuracy = [[dict valueForKey:@"accuracy"] integerValue];
                       NSString *address = [dict valueForKey:@"address"];
                       NSLog(@"lat：%f, lon: %f, accuracy: %ld, address: %@", lat, lon, (long)accuracy, address);
                       
                       if (address == NULL) {
                           address = @"Cannot get Wi-Fi Location";
                       }
                       
                       [self zoomToWifiAnnotations:@"Wi-Fi location" Subtitle:address];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           _searchingLabel.lineBreakMode = NSLineBreakByWordWrapping;
                           _searchingLabel.numberOfLines = 0;
                           [_searchingLabel setText:address];
                           /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wi-Fi Location" message:address preferredStyle:UIAlertControllerStyleAlert];
                           UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                           [alert addAction:okAction];
                           [self presentViewController:alert animated:YES completion:nil];*/
                       });
                   }
               }];
    [dataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)isInChina:(float) lat Lon:(float)lon {
    CLLocationCoordinate2D myCoOrdinate;
    
    myCoOrdinate.latitude = _latitude;
    myCoOrdinate.longitude = _longtitude;
    
    __block int isCN = 1;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:myCoOrdinate.latitude longitude:myCoOrdinate.longitude];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(placemarks.count > 0) {
            CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
            NSString *countryCode = myPlacemark.ISOcountryCode;
            NSString *countryName = myPlacemark.country;
            NSString *city1 = myPlacemark.subLocality;
            NSString *city2 = myPlacemark.locality;
            NSLog(@"My country code: %@, countryName: %@, city1: %@, city2: %@", countryCode, countryName, city1, city2);
            
            if ([countryCode isEqual:@"CN"] ) {
                isCN = 1;
            } else {
                isCN = 0;
            }
        }
    }];
    
    return isCN;
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
