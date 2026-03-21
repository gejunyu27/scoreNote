//
//  HomeCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/14.
//

#import <Foundation/Foundation.h>

#define kHomeCellH 180
#define kHomeCellId @"HomeCellId"

NS_ASSUME_NONNULL_BEGIN
@class HomeCell;

@protocol HomeCellDelegate <NSObject>
- (void)homeCellTagSelect:(RecordModel *)record;                                      //选择标签
- (void)homeCellEditRealNum:(RecordModel *)record clickView:(UIView *)clickView;      //修改实际期数
- (void)homeCellEditScore:(RecordModel *)record clickView:(UIView *)clickView;        //修改买法
- (void)homeCellBuy:(RecordModel *)record clickView:(UIView *)clickView;              //立即购买
- (void)homeCellShowDetails:(RecordModel *)record;                                    //查看详情
- (void)homeCellOverRecord:(RecordModel *)record;                                     //结束单子
- (void)homeCellBuyLose:(RecordModel *)record;                                        //未中
- (void)homeCellBuyWin:(RecordModel *)record clickView:(UIView *)clickView;           //红单

@end

@interface HomeCell : UITableViewCell

@property (nonatomic, weak) id <HomeCellDelegate> delegate;
@property (nonatomic, strong) RecordModel *record;

@end

NS_ASSUME_NONNULL_END
