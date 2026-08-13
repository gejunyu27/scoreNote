//
//  LineModel.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import <Foundation/Foundation.h>
@class RecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface LineModel : NSObject
//id
@property (nonatomic, copy) NSString *lineId;
//支出
@property (nonatomic, assign) CGFloat outMoney;
//收入
@property (nonatomic, assign) CGFloat getMoney;
//是否结束
@property (nonatomic, assign) BOOL isOver;
//结束时保存买法
@property (nonatomic, copy) NSString *overScore;

//开始时间
@property (nonatomic, strong) NSDate *beginTime;
//结束时间
@property (nonatomic, strong) NSDate *endTime;

//父级属性
@property (nonatomic, copy) NSString *recordId;

//非数据库字段
@property (nonatomic, weak) RecordModel *record; //方便使用 添加一个弱引用对象

@end

NS_ASSUME_NONNULL_END
