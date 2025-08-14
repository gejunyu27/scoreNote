//
//  TagModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagModel : NSObject
//id
@property (nonatomic, assign) NSInteger tagId;
//名称
@property (nonatomic, copy) NSString *name;
//最大期
@property (nonatomic, assign) NSInteger maxCount;

//非数据库属性
@property (nonatomic, copy, readonly) NSString *pinyinFirstChar;  //拼音首字母
@property (nonatomic, assign) BOOL isEdit;                        //是否在编辑中


@end

NS_ASSUME_NONNULL_END
