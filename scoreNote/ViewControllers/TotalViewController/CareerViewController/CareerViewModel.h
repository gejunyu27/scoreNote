//
//  CareerViewModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/3.
//

#import <Foundation/Foundation.h>
#import "CareerModel.h"
@class TotalSectionModel;

NS_ASSUME_NONNULL_BEGIN

@interface CareerViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray <CareerModel *> *careerList;

- (void)setSectionList:(nullable NSMutableArray <TotalSectionModel *> *)sectionList startRecord:(nullable RecordModel *)startRecord;

@end

NS_ASSUME_NONNULL_END
