//
//  TagCell.h
//  scoreNote
//
//  Created by gejunyu on 2023/5/1.
//

#import <UIKit/UIKit.h>

#define kTagCell @"TagCell"

@protocol TagCellDelegate <NSObject>
- (void)tagCellEditName:(NSString *_Nullable)name model:(TagModel *_Nonnull)model;
- (void)tagCellEditMaxCount:(NSInteger)maxCount model:(TagModel *_Nonnull)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TagCell : UITableViewCell
@property (nonatomic, strong) TagModel *model;
@property (nonatomic, weak) id <TagCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
