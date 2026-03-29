//
//  NetworkReachability.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
};

@interface NetworkReachability : NSObject

//网络状态
+ (NetworkStatus)currentNetworkStatus;
//是否允许网络
+ (BOOL)isReachable;
//开始监测网络变化
+ (void)startMonitorNetwork:(baseBlock)block;
//停止监测网络变化
+ (void)stopMontitorNetwork;
@end
