//
//  config.h
//  Pao123
//
//  Created by Zhenyong Chen on 6/8/15.
//  Copyright (c) 2015 XingJian Software. All rights reserved.
//

#ifndef __config_h
#define __config_h

#define MAPAPIKEY     @"ba3f5f63c0cbc81301bd286207e2edb0";


#define IOS_DEVICE 1
#define ANDROID_DEVICE 2
#define SERVER @"http://121.40.128.16/api"

#define MOBILE_PHONE_NUMBER  @"^1(3[0-9]|7[0-9]|5[0-35-9]|8[0125-9])\\d{8}$"
#define ACCEPT_FRIEND 1
#define REJECT_FRIEND 2

#define URL_USER_LOGIN SERVER @"/login"
#define URL_USER_REGISTER SERVER @"/register"
#define URL_GET_GPS SERVER @"/gps/"
#define URL_GET_CELLBASE SERVER @"/cellbase/"
#define URL_BOND_DEVICE SERVER @"/bonddevice"

//---- Menu ----
#define  rate_pixel_to_point  1.0
#define lo_menu_width   793/4
#define lo_menu_header_height   590/4
#define lo_menu_photo_y_offset   97/4
#define lo_menu_photo_diameter   272/4
#define lo_menu_nickname_y_offset   422/4
#define lo_menu_nickname_height   80/4
#define lo_menu_item_size   305/4
#define TITLEBARHEIGHT 44

//---- XJSettingsVC ----
#define  lo_settings_icon_size   205/4
#define  lo_settings_icon_x_center_offset   224/4
#define  lo_settings_icon_y_center_offset  342/4
#define  lo_settings_table_y_offset  (569 - 320)/4
#define  lo_settings_cell_switch_width  104/4
#define  lo_settings_cell_switch_height   64/4

#define DEFBKCOLOR [UIColor colorWithRed:0x24/255.0 green:0x25/255.0 blue:0x2a/255.0 alpha:1.0]

#define STATUSBARTINTCOLOR [UIColor colorWithRed:50/255.0 green:50/255.0 blue:70/255.0 alpha:1.0] // transparent
#define DEFFGCOLOR [UIColor colorWithRed:50/255.0 green:50/255.0 blue:70/255.0 alpha:1.0]

#define MENU_NICKNAME_FONT_COLOR [UIColor whiteColor]
#define MENU_USER_NICKNAME_FONT_SIZE (23*2*rate_pixel_to_point/4)
#define MENU_ITEM_ICON_SIZE (96/2/4)
#define MENU_ITEM_TITLE_FONT_SIZE (21*2*rate_pixel_to_point/4)

// Parameters for settings
#define SETTINGS_NICKNAME_FONT_SIZE (22*2*rate_pixel_to_point/2)
#define SETTINGS_CELL_TITLE_FONT_SIZE (20*2*rate_pixel_to_point/2)
#define SETTINGS_CELL_SUBTITLE_FONT_SIZE (16*2*rate_pixel_to_point/4)

#define MAJORDATA_TITLE_ABS_Y ((481.0-10)*rate_pixel_to_point)
#define MAJORDATA_TITLE_FONT_NAME @"Roboto-Light"
#define MAJORDATA_TITLE_FONT_SIZE (82*2*rate_pixel_to_point) // psd file: uses 2x DPI
#define NAVIGATIONBAR_LEFT_ICON_SIZE 44

#define NAVIGATIONBAR_TITLE_FONT_NAME @"UniSansThinCAPS"
//#define NAVIGATIONBAR_TITLE_FONT_NAME @"Helvetica"
#define NAVIGATIONBAR_TITLE_FONT_SIZE (26*2*rate_pixel_to_point)
#define NAVIGATIONBAR_SIDE_FONT_SIZE (20*2*rate_pixel_to_point)


#define EF_UPDATE_STATE 1
#define EF_UPDATE_LOCATION 2
#define EF_UPDATE_HEARTRATE 4
#define EF_UPDATE_REALTIME 8
#define EF_UPDATE_DURATION 16
#define EF_UPDATE_ALL 0xffffffffffffffff

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

NSString * stringFromDate(NSDate *date);
NSDate * getDateFromString(NSString *string);
NSDate * getDateFromDictionary(NSDictionary *dict, NSString *key);
NSMutableAttributedString * formatText(NSString *title, NSString *sub, BOOL head);
NSString *gpsLevel(double acc);


#define DEBUG_ENTER \
do { \
AppDelegate *app = [[UIApplication sharedApplication] delegate]; \
NSString *log = [NSString stringWithFormat:@"Entering %s:%d\n", __PRETTY_FUNCTION__, __LINE__]; \
[app XJLog:log]; \
NSLog(@"%@",log); \
} while (0)

#define DEBUG_LEAVE \
do { \
AppDelegate *app = [[UIApplication sharedApplication] delegate]; \
NSString *log = [NSString stringWithFormat:@"Leaving %s:%d\n", __PRETTY_FUNCTION__, __LINE__]; \
[app XJLog:log]; \
NSLog(@"%@",log); \
} while (0)

#endif
