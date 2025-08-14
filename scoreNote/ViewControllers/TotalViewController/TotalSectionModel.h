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
@property (nonatomic, assign) CGFloat allProfit;
@property (nonatomic ,strong) NSMutableArray <RecordModel *> *recordList;
@property (nonatomic, assign) BOOL isOn; //是否展开
@property (nonatomic, assign) BOOL isFollowing; //是否正在进行中

@end

NS_ASSUME_NONNULL_END
