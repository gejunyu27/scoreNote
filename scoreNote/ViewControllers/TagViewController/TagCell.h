//
//  TagCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/26.
//

#import <Foundation/Foundation.h>

#define kTagCellId @"kTagCellId"
#define kTagCellH  40

@protocol TagCellDelegate <NSObject>
- (void)tagCellEditName:(NSString *)name model:(TagModel *)model;
- (void)tagCellEditMaxCount:(TagModel *)model clickView:(UIView *)clickView;
- (void)tagCellDelete:(TagModel *)model;

@end

@interface TagCell : UITableViewCell
@property (nonatomic, strong) TagModel *model;
@property (nonatomic, weak) id <TagCellDelegate> delegate;
@end

