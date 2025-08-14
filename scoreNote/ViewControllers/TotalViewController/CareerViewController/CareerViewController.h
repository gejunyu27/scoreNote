//
//  CareerViewController.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/1.
//

#import "BaseViewController.h"
@class TotalSectionModel;

NS_ASSUME_NONNULL_BEGIN

@interface CareerViewController : BaseViewController
- (void)setSectionList:(nullable NSMutableArray <TotalSectionModel *> *)sectionList startRecord:(nullable RecordModel *)startRecord;

@end

NS_ASSUME_NONNULL_END
