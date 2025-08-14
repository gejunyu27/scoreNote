//
//  ColumnModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColumnModel : NSObject
@property (nonatomic, copy) NSString *name;     //名称
@property (nonatomic, copy) NSString *type;     //类型
@property (nonatomic, assign) BOOL notnull;     //是否不能为空

//不需要用到的属性
//@property (nonatomic, assign) BOOL pk;          //是否主键 不用
//@property (nonatomic, copy) NSString *dflt_value; //默认属性 不用
//@property (nonatomic, assign) NSInteger cid; //id 不用

//生成model
+ (nullable ColumnModel *)parsingModelWithName:(NSString *)name type:(NSString *)type notnull:(BOOL)notnull;
+ (nullable ColumnModel *)parsingModelWithName:(NSString *)name type:(NSString *)type;

- (NSString *)descriptionRemoveName;

@end

NS_ASSUME_NONNULL_END
