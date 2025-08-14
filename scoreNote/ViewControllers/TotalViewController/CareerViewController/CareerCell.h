//
//  CareerCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/3.
//

#import <UIKit/UIKit.h>
@class CareerModel;

NS_ASSUME_NONNULL_BEGIN

@interface CareerCell : UITableViewCell
- (void)setData:(CareerModel *)model row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
