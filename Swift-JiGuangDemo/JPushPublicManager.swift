//
//  JPushPublicManager.swift
//  Swift-JiGuangDemo
//
//  Created by 贺文杰 on 2019/12/27.
//  Copyright © 2019 贺文杰. All rights reserved.
//

import Foundation
import UIKit

let AppKey = "08f2e9a8b5fb855adab6b61a"

let sharedManager = JPushPublicManager()

// 极光文档官网：http://docs.jiguang.cn/jpush/client/iOS/ios_new_fetures/
class JPushPublicManager : NSObject{
    
    override init() {
        super.init()
    }
    
    func JPUSHInit(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        let entity = JPUSHRegisterEntity.init()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue | JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
        } else {
            entity.types = Int(JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
        }
        let device = UIDevice.init()
        let version = (device.systemVersion as NSString).doubleValue
        if version >= 8.0 {
            //自定义 categories
        }
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        JPUSHService.setup(withOption: launchOptions, appKey: AppKey, channel: "iOS", apsForProduction: false)
        
        //获取registrationID上送至服务端
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            print("resCode = \(resCode), registrationID = \(String(describing: registrationID))")
        }
    }
    
    func registerDeviceToken(_ deviceToken: Data!){
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func handleRemoteNotification(_ userInfo: [AnyHashable : Any]!, _ completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension JPushPublicManager : JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
        if (notification != nil) && (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        if (response != nil) && (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            JPUSHService.handleRemoteNotification(response.notification.request.content.userInfo)
        }else{
            
        }
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        if (notification != nil) && (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            JPUSHService.handleRemoteNotification(notification.request.content.userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    //监测通知授权状态返回的结果
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
}
