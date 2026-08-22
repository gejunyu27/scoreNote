//
//  CommonCornerCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonCornerCell : UITableViewCell

@property (nonatomic, assign) CGFloat edge;        //内容距离屏幕边距 default 15
@property (nonatomic, assign) CGFloat lineMargin;  //分割线边距 default 15

@property (nonatomic, strong, readonly) UIView *sepLine;

- (void)updateCornerWithIndex:(NSInteger)index dataCount:(NSInteger)dataCount;
@end

NS_ASSUME_NONNULL_END
