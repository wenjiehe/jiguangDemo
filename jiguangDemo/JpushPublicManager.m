//
//  JpushPublicManager.m
//  jiguangDemo
//
//  Created by 贺文杰 on 2019/12/26.
//  Copyright © 2019 贺文杰. All rights reserved.
//

#import "JpushPublicManager.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

#define JPushKey @"08f2e9a8b5fb855adab6b61a"

// 极光文档官网：http://docs.jiguang.cn/jpush/client/iOS/ios_new_fetures/
@interface JpushPublicManager ()<JPUSHRegisterDelegate>

@end

@implementation JpushPublicManager

+ (instancetype)sharedInstance
{
    static JpushPublicManager *sharedInstance = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[JpushPublicManager alloc] init];
    });
    return sharedInstance;
}

- (void)JPUSHInit:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types = JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    }
    UIDevice *device = [[UIDevice alloc] init];
    if (device.systemVersion.floatValue >= 8.0) {
        //自定义 categories
    }
        
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey channel:@"iOS" apsForProduction:NO];
    
    //获取registrationID上送至服务端
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode = %d, registrationID = %@", resCode, registrationID);
    }];
}

- (void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo handle:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -- JPUSH Register Delegate
/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler
API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

/*
 * @brief handle UserNotifications.framework [didReceiveNotificationResponse:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param response 通知响应对象
 * @param completionHandler
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

/*
 * @brief handle UserNotifications.framework [openSettingsForNotification:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 当前管理的通知对象
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification NS_AVAILABLE_IOS(12.0)
{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      //从通知界面直接进入应用
    }else{
      //从通知设置界面进入应用
    }
}

/**
 * 监测通知授权状态返回的结果
 * @param status 授权通知状态，详见JPAuthorizationStatus
 * @param info 更多信息，预留参数
 */
- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info
{
    
}

@end
