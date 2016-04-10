//
//  GdTrackOverlayView.h
//  Pao123
//
//  Created by Zhenyong Chen on 7/3/15.
//  Copyright (c) 2015 XingJian Software. All rights reserved.
//

#import <MapKit/MKOverlayPathView.h>
#import "GdTrackOverlay.h"

@interface GdTrackOverlayView : MKOverlayPathView

@property (nonatomic, readonly) GdTrackOverlay *trackOverlay;

- (id)initWithTrackOverlay:(GdTrackOverlay *)overlay;

@end
