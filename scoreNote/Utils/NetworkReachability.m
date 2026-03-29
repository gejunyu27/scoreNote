//
//  NetworkReachability.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/29.
//

#import "NetworkReachability.h"

#import "NetworkReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTCellularData.h>
#import <netinet/in.h>

@interface NetworkReachability ()
@property (nonatomic, copy) baseBlock monitorBlock;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation NetworkReachability

DEF_SINGLETON(NetworkReachability)

+ (NetworkStatus)currentNetworkStatus
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    NetworkStatus status = NotReachable;
    
    if (reachability != NULL) {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
                status = NotReachable;
            } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                status = ReachableViaWWAN;
            } else {
                status = ReachableViaWiFi;
            }
        }
        CFRelease(reachability);
    }
    return status;
}

+ (BOOL)isReachable {
    return [self currentNetworkStatus] != NotReachable;
}


//开始监测网络变化
+ (void)startMonitorNetwork:(baseBlock)block
{
    NetworkReachability *nr = [self sharedInstance];
    
    nr.monitorBlock = block;
    
    
    // GCD 定时器，0.5 秒检测一次
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    nr.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(nr.timer, dispatch_time(DISPATCH_TIME_NOW, 0), 0.5 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(nr.timer, ^{
        BOOL isReachable = [NetworkReachability isReachable];
        
        if (isReachable) {
            // ✅ 网络通了（用户刚点允许）→ 触发回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nr.monitorBlock) {
                    nr.monitorBlock();
                }
                // 停止监听
                dispatch_source_cancel(nr.timer);
            });
        }
    });
    dispatch_resume(nr.timer);
}


//停止监测网络变化
+ (void)stopMontitorNetwork
{
    NetworkReachability *nr = [self sharedInstance];
    
    if (nr.timer) {
        dispatch_source_cancel(nr.timer);
        nr.timer = nil;
    }
    
}


@end
