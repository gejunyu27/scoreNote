//
//  TestCell.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/23.
//

#import <Foundation/Foundation.h>

#define kTagCellId @"kTagCellId"
#define kTagCellH  40

NS_ASSUME_NONNULL_BEGIN

@protocol TagCellDelegate <NSObject>
- (void)tagCellEditName:(NSString *_Nullable)name model:(TagModel *_Nonnull)model;
- (void)tagCellEditMaxCount:(TagModel *_Nonnull)model clickView:(UIView *_Nullable)clickView;
- (void)tagCellDelete:(TagModel *_Nonnull)model;

@end

@interface TestCell : UITableViewCell
@property (nonatomic, strong) TagModel *model;
@property (nonatomic, weak) id <TagCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
