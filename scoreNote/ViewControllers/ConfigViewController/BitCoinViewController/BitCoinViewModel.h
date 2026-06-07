//
//  BitCoinViewModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/7.
//

#import <Foundation/Foundation.h>
#import "BitCoinModel.h"
#import "FinanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BitCoinViewModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <BitCoinModel *> *dataList;
@property (nonatomic, weak, readonly) NSArray <FinanceModel *> *financeList;

- (void)saveData;

@end

NS_ASSUME_NONNULL_END
