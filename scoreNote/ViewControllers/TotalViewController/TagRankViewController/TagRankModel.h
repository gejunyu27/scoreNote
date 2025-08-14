//
//  TagRankModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagRankModel : NSObject

@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray <RecordModel *> *recordList;
@property (nonatomic, assign) CGFloat allProfit;
 
@end

NS_ASSUME_NONNULL_END
