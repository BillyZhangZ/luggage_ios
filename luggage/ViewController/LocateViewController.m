//
//  MainViewController.m
//  luggage
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "LocateViewController.h"
#import <MAMapKit/MAMapKit.H>
#import "config.h"

#define APIKEY     @"ba3f5f63c0cbc81301bd286207e2edb0";

@interface LocateViewController ()<MAMapViewDelegate, UIGestureRecognizerDelegate>
{
    MAMapView *_mapView;
    UIButton  *_currentLocationButton;
    UIButton  *_lockCompassDirectionButton;
    UIButton  *_mapModeButton;
    
    CLLocationDegrees _longtitude;
    CLLocationDegrees _latitude;
}
@end

@implementation LocateViewController


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
    [MAMapServices sharedServices].apiKey = APIKEY;
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
    [self.view addSubview:_mapModeButton];
    [self.view addSubview:_mapView];
    [self.view bringSubviewToFront:_mapModeButton];
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
    
    NSMutableString *urlPost = [[NSMutableString alloc] initWithString:URL_GET_GPS];
    [urlPost appendFormat:@"%lu",(unsigned long)userId];
    NSURL *url = [NSURL URLWithString:urlPost];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [request setHTTPMethod:@"GET"];

    [request setTimeoutInterval:10.0f];
    
    void (^onDone)(NSData *data) = ^(NSData *data) {
        if(data == nil)
        {
            NSLog(@"获取gps数据失败%d",userId);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"获取位置失败" message:@"请再试一下下" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dict == nil || [dict objectForKey:@"userId"] == NULL) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"位置数据格式错误" message:@"请再试一下下" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        _latitude = [[dict valueForKey:@"latitude"] floatValue];
        _longtitude = [[dict valueForKey:@"longtitude"] floatValue];
        [self zoomToAnnotations];
        NSLog(@"gps raw data %@",dict);
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
    return UIDeviceOrientationPortrait;
}
@end
