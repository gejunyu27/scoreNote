//
//  ConfigFunctionCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"

#define kCFCellH   50
#define kCFCellId  @"kCFCellId"

NS_ASSUME_NONNULL_BEGIN

@protocol ConfigFunctionDelegate <NSObject>
- (void)functionCellPushBitCoin;
- (void)functionCellPushDeveloper;
- (void)functionCellSaveData;
- (void)functionCellDeleteData;


@end

@interface ConfigFunctionCell : UITableViewCell
@property (nonatomic, strong) ConfigModel *model;
@property (nonatomic, weak) id <ConfigFunctionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
