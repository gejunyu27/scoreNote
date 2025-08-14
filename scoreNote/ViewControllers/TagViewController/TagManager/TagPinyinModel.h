//
//  TagPinyinModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagPinyinModel : NSObject
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, strong) NSMutableArray <TagModel *> *tagList;

@property (nonatomic, assign) BOOL isOn; //控制开闭

@end

NS_ASSUME_NONNULL_END
