//
//  TotalSectionModel.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TotalSectionModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign, readonly) CGFloat allProfit;
@property (nonatomic, assign, readonly) CGFloat allGet;
@property (nonatomic, assign, readonly) CGFloat allOut;
@property (nonatomic ,strong, readonly) NSArray <RecordModel *> *recordList;
@property (nonatomic, assign) BOOL isOn; //是否展开
@property (nonatomic, assign) BOOL isFollowing; //是否正在进行中

//新增比特币数据
@property (nonatomic, assign, readonly) CGFloat bitcoinOut;
@property (nonatomic, assign, readonly) CGFloat bitcoinGet;
@property (nonatomic, assign, readonly) CGFloat bitcoinProfit;

//单子操作
- (void)addRecord:(RecordModel *)record;

@end

NS_ASSUME_NONNULL_END
