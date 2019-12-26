//
//  JpushPublicManager.h
//  jiguangDemo
//
//  Created by 贺文杰 on 2019/12/26.
//  Copyright © 2019 贺文杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

NS_ASSUME_NONNULL_BEGIN

@interface JpushPublicManager : NSObject

+ (instancetype)sharedInstance;

- (void)JPUSHInit:(NSDictionary *)launchOptions;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)handleRemoteNotification:(NSDictionary *)userInfo handle:(nonnull void (^)(UIBackgroundFetchResult))completionHandler;

@end

NS_ASSUME_NONNULL_END
