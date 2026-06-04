//
//  TotalViewModel.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import <Foundation/Foundation.h>
#import "TotalSectionModel.h"
#import "FinanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TotalViewModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <TotalSectionModel *> *sectionList;

//第一单
@property (nonatomic, strong, readonly) RecordModel *startRecord;

//收益数据合集
@property (nonatomic, strong, readonly) NSArray <FinanceModel *> *financeModels;

//是否需要更新数据 以收到通知为准
@property (nonatomic, assign) BOOL needUpdate;

//更新数据
- (void)update;


@end


NS_ASSUME_NONNULL_END
