//
//  RecordDetailCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kRDCellH  60
#define kRDCellId @"kRDCellId"

@protocol RecordDetailCellDelegate <NSObject>

- (void)recordDetailCellEditOutMoney:(LineModel *)line clickView:(UIView *)clickView;
- (void)recordDetailCellEditGetMoney:(LineModel *)line clickView:(UIView *)clickView;

@end

@interface RecordDetailCell : UITableViewCell
@property (nonatomic, weak) id <RecordDetailCellDelegate> delegate;
- (void)setLine:(LineModel *)line row:(NSInteger)row canEdit:(BOOL)canEdit;

@end

NS_ASSUME_NONNULL_END
