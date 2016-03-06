//
//  FootprintViewController.m
//  luggage
//
//  Created by 张志阳 on 12/7/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import "ZZYFootprintVC.h"
#import <MAMapKit/MAMapKit.H>
#import "config.h"
#import "AppDelegate.h"
#import "GdTrackOverlay.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ZZYFootprintVC ()<MAMapViewDelegate, UIGestureRecognizerDelegate>
{
    MAMapView *_mapView;
    UIButton  *_currentLocationButton;
    UIButton  *_lockCompassDirectionButton;
    UIButton  *_mapModeButton;
    
    CLLocationDegrees _longtitude;
    CLLocationDegrees _latitude;
    CLLocationDistance _altitude;
}
@end

@implementation ZZYFootprintVC


- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreenEdgePanGestureRecognizer * screenEdgePan
    = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    screenEdgePan.delegate = self;
    screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    [MAMapServices sharedServices].apiKey = MAPAPIKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.mapType = MAMapTypeStandard;
    _mapView.showTraffic= NO;
    
    //_mapView.language = MAMapLanguageEn;
    _mapView.showsUserLocation = NO;
    [_mapView setUserTrackingMode: MAUserTrackingModeNone animated:YES]; //地图跟着位置 移动
    
    _mapView.pausesLocationUpdatesAutomatically = NO;
#if 0
    _mapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *mapTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onMapView:)];
    [_mapView addGestureRecognizer:mapTapGesture];
#endif
    _mapView.delegate = self;
#if 1
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(31.43715199999999,121.13612);
    MACoordinateSpan span = MACoordinateSpanMake(0.04, 0.04);
    _mapView.region = MACoordinateRegionMake(coord, span);
#endif
    //[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(zoomToAnnotations) userInfo:nil repeats:NO];
    
    
    //buttons
    _mapModeButton =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 100, CGRectGetHeight(self.view.bounds) - 60, 80, 40)];
    _mapModeButton.backgroundColor = [UIColor clearColor];
    [_mapModeButton setTitle:@"夜间模式" forState:UIControlStateNormal];
    [_mapModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _mapModeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_mapModeButton addTarget:self action:@selector(onMapButtonMode) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self getLatestLocation:1];
    //[self.view addSubview:_mapModeButton];
    [self.view addSubview:_mapView];
    //[self.view bringSubviewToFront:_mapModeButton];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}


- (void) onMapButtonMode
{
    switch (_mapView.mapType) {
        case MAMapTypeStandard:
            _mapView.mapType = MAMapTypeStandardNight;
            [_mapModeButton setTitle:@"标准模式" forState:UIControlStateNormal];
            break;
        default:
            _mapView.mapType = MAMapTypeStandard;
            [_mapModeButton setTitle:@"夜间模式" forState:UIControlStateNormal];
            
            break;
    }
}


-(void)zoomToAnnotations
{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    //annotation.coordinate = CLLocationCoordinate2DMake(31.43715199999999, 121.13612);
    annotation.coordinate = CLLocationCoordinate2DMake(_latitude, _longtitude);
    
    annotation.title = @"东仓花园";
    annotation.subtitle = @"中国机械加工网";
    // 指定新的显示区域
    [_mapView setRegion:MACoordinateRegionMake(annotation.coordinate, MACoordinateSpanMake(0.04,0.04)) animated:YES];
    // 选中标注
    ///[_mapView selectAnnotation:annotation animated:YES];
    [_mapView addAnnotation:annotation];
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    NSLog(@"annotation selected\n");
}


- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)getLatestLocation:(NSInteger)userId
{
    
    NSMutableString *urlGet = [[NSMutableString alloc] initWithString:URL_GET_GPS];
    [urlGet appendFormat:@"%lu/%d",(unsigned long)userId, 100/*stringFromDate([NSDate date])*/];
    //[urlGet appendFormat:@"%lu/%@/%@",(unsigned long)userId, stringFromDate([[NSDate date] dateByAddingTimeInterval:-3600]), stringFromDate([NSDate date])];

    NSURL *url = [NSURL URLWithString:urlGet];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [request setHTTPMethod:@"GET"];
    
    [request setTimeoutInterval:100.0f];
    
    void (^onDone)(NSData *data) = ^(NSData *data) {
        if(data == nil)
        {
            NSLog(@"获取gps数据失败%d",userId);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取位置失败" message:@"请再试一下下" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];

            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *dicts = [allData valueForKey:@"gps"];
        if (dicts == nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"位置数据格式错误" message:@"请再试一下下" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        int i = 0;
        
        CLLocationCoordinate2D pointsToUse[[dicts count]];

        for (NSDictionary *dict in dicts) {
            //GPGGA ddmm.mm -> ddd.ddddd
#if 0
            float lat = [[dict valueForKey:@"latitude"] floatValue];
            _latitude = ((int)lat)/100;
            lat = ((int)(lat*10000))%1000000;
            lat /= (60*10000);
            _latitude += lat;
        
            float lon = [[dict valueForKey:@"longtitude"] floatValue];
            _longtitude = ((int)lon)/100;
            lon = ((int)(lon*10000))%1000000;
            lon /= (60*10000);
            _longtitude += lon;
#else
            _longtitude = [[dict valueForKey:@"longtitude"] floatValue];
            _latitude = [[dict valueForKey:@"latitude"] floatValue];
#endif
            _altitude = [[dict valueForKey:@"altitude"] floatValue];
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(_latitude, _longtitude);
            CLLocationCoordinate2D coords;
            coords.latitude = _latitude;
            coords.longitude = _longtitude;
            //coord convert
            coord = transformFromWGSToGCJ(coords);
            pointsToUse[i++] =  coord;
            
            //CLLocation *locNew = [[CLLocation alloc] initWithCoordinate:coord altitude: _altitude horizontalAccuracy:10.0     verticalAccuracy:10.0 timestamp:[NSDate date]];
            //CLLocation *locNew = [[CLLocation alloc] initWithCoordinate:coord altitude: _altitude horizontalAccuracy:10.0 verticalAccuracy:10.0 course:0 speed:0.0 timestamp:[NSDate date]];
            
            
            NSLog(@"gps raw data %@",dict);
        }
        NSMutableArray *overlays = [[NSMutableArray alloc] init];

        MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[dicts count]];
        lineOne.title = @"red";
        [overlays addObject:lineOne];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(pointsToUse[[dicts count] - 1].latitude,pointsToUse[[dicts count] - 1].longitude);
        MACoordinateSpan span = MACoordinateSpanMake(0.04, 0.04);
        _mapView.region = MACoordinateRegionMake(coord, span);
        //[self updatePaths:overlays];
        [_mapView addOverlays:overlays];
    };
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error == nil && data != nil) {
                                   onDone(data);
                               }
                               else {
                                   onDone(nil);
                               }
                           }];
    
}
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id )overlay{
   // if ([overlay isKindOfClass:[MAPolyline class]]){
        MAPolylineView *lineView = [[MAPolylineView alloc] initWithPolyline: overlay];
        lineView.lineWidth = 5.0f;
        lineView.strokeColor = [UIColor redColor];
        lineView.fillColor = [UIColor blackColor];
        return lineView;
  //  }
    
 //   return nil;
}

-(void) updatePaths:(NSMutableArray *)arrayOfPointList
{
    [_mapView addOverlay:[GdTrackOverlay initWithCoordinates:arrayOfPointList]];
    
#if 0
    // set annotations
    if(workoutOverlay.annotationStart == nil) {
        for(NSUInteger i=0; i<sessionCount; i++) {
            XJSession *session = [sessions objectAtIndex:i];
            if(session != nil) {
                CLLocation *firstLoc = session.locations.firstObject;
                if(firstLoc != nil)
                {
                    workoutOverlay.annotationStart = [self setAnnotationAt:firstLoc.coordinate withTitle:@"起点" withSubTitle:stringFromDate(firstLoc.timestamp)];
                    break;
                }
            }
        }
    }

    CLLocation *lastLoc = workoutOverlay.overlay.lastLocation;
    if(lastLoc != nil) {
        if(workoutOverlay.annotationEnd != nil) {
            [self.gdMapView removeAnnotation:workoutOverlay.annotationEnd];
        }
        workoutOverlay.annotationEnd = [self setAnnotationAt:lastLoc.coordinate withTitle:@"终点" withSubTitle:stringFromDate(lastLoc.timestamp)];
    }
#endif
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - disable landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIDeviceOrientationPortrait);
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
