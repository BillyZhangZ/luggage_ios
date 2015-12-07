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

#define URL_USER_LOGIN SERVER @"/user/"
#define URL_USER_REGISTER SERVER @"/user/"
#define URL_GET_GPS SERVER @"/gps/"

#define REMOTE_SERVER  SERVER @"/xingjiansport/V1/Workout/saveWorkoutSegment/"
#define URL_GET_WORKOUT SERVER @"/xingjiansport/V1/Workout/getWorkoutInfo/id/"
#define URL_GET_WORKOUT_LIST SERVER @"/xingjiansport/V1/Workout/listWorkout/userid/"
#define URL_DELETE_WORKOUT SERVER @"/xingjiansport/V1/Workout/removeWorkout/id/"

#define URL_POST_DEBUGINFO SERVER @"/xingjiansport/V1/Workout/saveDebugInfo"
#define URL_GET_USER_INFO SERVER @"/xingjiansport/V1/User/getGuestUserId/"

#define URL_UPDATE_USER_INFO SERVER @"/xingjiansport/V1/User/updateUserInfo/id/"

#define URL_PULL_REALTIME_WORKOUT SERVER @"/xingjiansport/V1/Workout/getLatestData/userid/"

#define URL_SEARCH_USER_BY_NAME SERVER @"/xingjiansport/V1/User/searchUserByName/name/"
#define URL_SEARCH_USERS_BY_NAME_LIST SERVER @"/xingjiansport/V1/User/searchUserByNameList/name/"
#define URL_ADD_FRIEND SERVER @"/xingjiansport/V1/User/addFriends/id/"
#define URL_GET_FRIEND_LIST SERVER @"/xingjiansport/V1/User/getFriendList/id/"
#define URL_GET_APPLY_FRIEND_LIST SERVER @"/xingjiansport/V1/User/getApplyFriendList/id/"
#define URL_APPLY_TO_ADD_FRIEND SERVER @"/xingjiansport/V1/User/applyAddFriend/"
#define URL_APPROVE_FRIEND_APPLY SERVER @"/xingjiansport/V1/User/approveAddFriend/"

#define URL_CREATE_RUN_GROUP            SERVER @"/xingjiansport/V1/Rungroup/createRungroup/userid/"
#define URL_GET_USER_RUN_GROUP_INFO          SERVER @"/xingjiansport/V1/Rungroup/getPersonRungroupInfo/userid/"
#define URL_SEARCH_RUN_GROUP            SERVER @"/xingjiansport/V1/Rungroup/queryRungroup/name/"
#define URL_GET_RUN_GROUP_INFO          SERVER @"/xingjiansport/V1/Rungroup/getRungroupInfo/id/"
#define URL_USER_APPLY_RUN_GROUP        SERVER @"/xingjiansport/V1/Rungroup/applyJoinRungroup/"
#define URL_GET_RUN_GROUP_APPLY_INFO    SERVER @"/xingjiansport/V1/Rungroup/getRungroupApplicationList/id/"
#define URL_GET_RUN_GROUP_MEMBERS       SERVER @"/xingjiansport/V1/Rungroup/getRungroupMemberList/id/"
#define URL_APPROVE_JOIN_RUN_GROUP      SERVER @"/xingjiansport/V1/Rungroup/approveJoinRungroup/"


//---- Menu ----
#define  rate_pixel_to_point  1.0
#define lo_menu_width   793/4
#define lo_menu_header_height   590/4
#define lo_menu_photo_y_offset   97/4
#define lo_menu_photo_diameter   272/4
#define lo_menu_nickname_y_offset   422/4
#define lo_menu_nickname_height   54/4
#define lo_menu_item_size   305/4

#define MENU_NICKNAME_FONT_COLOR [UIColor whiteColor]
#define MENU_USER_NICKNAME_FONT_SIZE (23*2*rate_pixel_to_point/4)
#define MENU_ITEM_ICON_SIZE (96/2/4)
#define MENU_ITEM_TITLE_FONT_SIZE (21*2*rate_pixel_to_point/4)

// Parameters for settings
#define SETTINGS_NICKNAME_FONT_SIZE (22*2*rate_pixel_to_point)
#define SETTINGS_CELL_TITLE_FONT_SIZE (20*2*rate_pixel_to_point)
#define SETTINGS_CELL_SUBTITLE_FONT_SIZE (16*2*rate_pixel_to_point)

#define USERID 14

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
