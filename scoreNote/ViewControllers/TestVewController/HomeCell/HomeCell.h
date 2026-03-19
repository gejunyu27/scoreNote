//
//  HomeCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/14.
//

#import <Foundation/Foundation.h>

#define kHomeCellH 230
#define kHomeCellId @"HomeCellId"

NS_ASSUME_NONNULL_BEGIN
@class HomeCell;

@protocol HomeCellDelegate <NSObject>
- (void)homeCellTagSelect:(RecordModel *)record;                                           //选择标签
- (void)homeCellEditRealNum:(RecordModel *)record clickView:(UIView *)clickView;           //修改实际期数
- (void)homeCellAddRealNum:(RecordModel *)record;                                          //实际期数+1
- (void)homeCellEditScore:(RecordModel *)record clickView:(UIView *)clickView;             //修改买法
- (void)homeCellEditBreakLine:(RecordModel *)record clickView:(UIView *)clickView;         //修改止损线
- (void)homeCellEditProfitPerLine:(RecordModel *)record clickView:(UIView *)clickView;     //修改每期利润
- (void)homeCellEditBaseProfit:(RecordModel *)record clickView:(UIView *)clickView;        //修改固定利润
- (void)homeCellEditNote:(NSString *)note record:(RecordModel *)record;                    //修改笔记
- (void)homeCellBuy:(RecordModel *)record clickView:(UIView *)clickView;                   //立即购买
- (void)homeCellShowLines:(RecordModel *)record;                                           //查看列表
- (void)homeCellOverRecord:(RecordModel *)record;                                          //结束单子

@end

@interface HomeCell : UITableViewCell

@property (nonatomic, weak) id <HomeCellDelegate> delegate;
@property (nonatomic, strong) RecordModel *record;

@end

NS_ASSUME_NONNULL_END
