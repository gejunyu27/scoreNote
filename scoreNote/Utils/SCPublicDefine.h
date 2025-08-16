//
//  SCPublicDefine.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#ifndef SCPublicDefine_h
#define SCPublicDefine_h


#pragma mark -屏幕尺寸相关
//宽高
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
//像素适配
#define SCREEN_FIX(P)         ((float)floor((SCREEN_WIDTH * P) / 375.0))
//状态栏 导航栏
#define STATUS_BAR_HEIGHT     [UIApplication sharedApplication].delegate.window.windowScene.statusBarManager.statusBarFrame.size.height //如果隐藏状态栏，该取值会出错
#define NAV_BAR_HEIGHT        (STATUS_BAR_HEIGHT + 44.f)

//是否是刘海屏
#define IS_BANGS_SCREEN       (STATUS_BAR_HEIGHT > 20)
#define SCREEN_SAFE_BOTTOM    (IS_BANGS_SCREEN ? 34.f : 0.f)   //[UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom
#define TAB_BAR_HEIGHT        (SCREEN_SAFE_BOTTOM + 49.f)

//是否是x,12之类的大屏手机
#define IS_LARGE_SCREEN       (SCREEN_HEIGHT > 667)

#pragma mark - 常用
//默认图片
#define  IMG_PLACE_HOLDER   SCIMAGE(@"home_localLife_newsDefault")

//序号宽度
#define kMargin  20.0


//单例
#undef  AS_SINGLETON
#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;

#undef DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
  return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
  static dispatch_once_t once; \
  static __class * __singleton__; \
  dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
  return __singleton__; \
}

///-----------------
/// 打印日志定义
///-----------------
#ifdef DEBUG
//#  define NSLog(format, ...) NSLog((@"[函数名:%s]" "[行号:%d]" format), __FUNCTION__, __LINE__, ##__VA_ARGS__); //sdk对外使用,内部api不需要暴露
#else
#  define NSLog(...) nil;
#endif

//字体
#define SCFONT_SIZED(fontSize)                 [UIFont systemFontOfSize:fontSize]
#define SCFONT_BOLD_SIZED(fontSize)            [UIFont boldSystemFontOfSize:fontSize]
#define SCFONT_NAME_SIZED(fontName, fontSize)  [UIFont fontWithName:fontName size:fontSize]
//自适应大小
#define SCFONT_SIZED_FIX(fontSize)             [UIFont systemFontOfSize:SCREEN_FIX(fontSize)]
#define SCFONT_BOLD_SIZED_FIX(fontSize)        [UIFont boldSystemFontOfSize:SCREEN_FIX(fontSize)]


#define m6Scale (SCREEN_WIDTH/750)

// APP版本
#define APP_VERSION  ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"sys-clientVersion"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
// bundleId
#define BUNDLE_ID  [[NSBundle mainBundle] bundleIdentifier]
//
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]


#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#pragma mark - 键值
#define KEY_HIGH_PROFIT      @"KEY_HIGH_PROFIT"     //最高利润
#define KEY_LOW_PROFIT       @"KEY_LOW_PROFIT"      //最低利润  -790000
#define KEY_DB_VERSION       @"KEY_DB_VERSION"      //数据库版本

#pragma mark - 通知
#define NOTI_RECORD_UPDATE   @"NOTI_RECORD_UPDATE"  //记录更新
#define NOTI_SQLITE_UPDATE   @"NOTI_SQLITE_UPDATE"  //数据库更新
#define NOTI_CONFIG_UPDATE   @"NOTI_CONFIG_UPDATE"  //设置更新

#endif /* SCPublicDefine_h */
