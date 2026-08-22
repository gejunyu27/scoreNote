//
//  MonthModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/8.
//

#import <Foundation/Foundation.h>
#import "RecordModel.h"
@class YearModel;

NS_ASSUME_NONNULL_BEGIN

@interface MonthModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <RecordModel *> *records;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat allOut;
@property (nonatomic, assign) CGFloat allGet;
@property (nonatomic, assign) CGFloat allProfit;

@property (nonatomic, assign) BOOL isOn;

@property (nonatomic, weak) YearModel *yearModel; //弱引用一个父类属性，方便使用

//新增比特币数据
@property (nonatomic, assign, readonly) CGFloat bitcoinOut;
@property (nonatomic, assign, readonly) CGFloat bitcoinGet;
@property (nonatomic, assign, readonly) CGFloat bitcoinProfit;

- (void)updateData;

@end

NS_ASSUME_NONNULL_END
