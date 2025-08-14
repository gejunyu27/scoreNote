//
//  TagRankViewModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/20.
//

#import <Foundation/Foundation.h>
#import "TagRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagRankViewModel : NSObject
@property (nonatomic, strong) NSArray <TagRankModel *>* rankList;
@end

NS_ASSUME_NONNULL_END
