//
//  MainViewController.m
//  luggage
//
//  Created by 张志阳 on 11/22/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "LocateViewController.h"
#import <MAMapKit/MAMapKit.H>


#define APIKEY     @"ba3f5f63c0cbc81301bd286207e2edb0";

@interface LocateViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    UIButton  *_currentLocationButton;
    UIButton  *_lockCompassDirectionButton;
    UIButton  *_mapModeButton;
    
}
@end

@implementation LocateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    [MAMapServices sharedServices].apiKey = APIKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
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
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(zoomToAnnotations) userInfo:nil repeats:NO];
    
    
    //buttons
    _mapModeButton =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 100, 20, 80, 40)];
    _mapModeButton.backgroundColor = [UIColor clearColor];
    [_mapModeButton setTitle:@"夜间模式" forState:UIControlStateNormal];
    [_mapModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _mapModeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_mapModeButton addTarget:self action:@selector(onMapButtonMode) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
#if 0
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(39.95, 116.35);
    KCAnnotation *annotation1=[[KCAnnotation alloc]init];
    annotation1.title=@"CMJ Studio";
    annotation1.subtitle=@"Kenshin Cui's Studios";
    annotation1.coordinate=location1;
    [_mapView addAnnotation:annotation1];
    
#else
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(31.43715199999999, 121.13612);
    annotation.title = @"东仓花园";
    annotation.subtitle = @"中国机械加工网";
    // 指定新的显示区域
    [_mapView setRegion:MACoordinateRegionMake(annotation.coordinate, MACoordinateSpanMake(0.025,0.025)) animated:YES];
    // 选中标注
    ///[_mapView selectAnnotation:annotation animated:YES];
    [_mapView addAnnotation:annotation];
#endif
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    NSLog(@"annotation selected\n");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - disable landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
@end
