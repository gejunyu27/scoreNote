//
//  RecordModel.h
//  scoreNote
//
//  Created by gejunyu on 2022/1/29.
//

#import <Foundation/Foundation.h>
#import "TagModel.h"
#import "LineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordModel : NSObject
//id
@property (nonatomic, copy) NSString *recordId;
//标签id
@property (nonatomic,assign) NSInteger tagId;
//标签 非数据库属性
@property (nonatomic, copy, readonly) TagModel *tagModel;
//每期利润
@property (nonatomic, assign) CGFloat profitPerLine;
//基础利润
@property (nonatomic, assign) CGFloat baseProfit;
//创建时间
@property (nonatomic, strong) NSDate *createTime;
//结束时间
@property (nonatomic, strong) NSDate *endTime;
//实际期数
@property (nonatomic, assign) NSInteger realNum;
//笔记
@property (nonatomic, copy) NSString *note;
//是否结束 方便数据库查询用
@property (nonatomic, assign) BOOL isOver;
//开始时间 非数据库属性
@property (nonatomic, strong) NSDate *startTime;
//当期买法
@property (nonatomic, copy) NSString *currentScore;
//结束时的标签名
@property (nonatomic, copy) NSString *overTagName; //大部分情况用不到，只有旧标签删了才会用到

//列表
@property (nonatomic, strong) NSMutableArray <LineModel *> *lineList;

//动态属性
//总计收入
@property (nonatomic, assign, readonly) CGFloat allGet;
//总计支出
@property (nonatomic, assign, readonly) CGFloat allOut;
//总计利润
@property (nonatomic, assign, readonly) CGFloat allProfit;

@end


NS_ASSUME_NONNULL_END
