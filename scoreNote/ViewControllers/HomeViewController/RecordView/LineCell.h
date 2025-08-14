//
//  LineCell.h
//  scoreNote
//
//  Created by gejunyu on 2022/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineCell : UITableViewCell
//列数据
@property (nonatomic, strong, nullable) LineModel *model;

@property (nonatomic, copy) void (^updateBlock)(LineModel *line);

@property (nonatomic, copy) void (^addBlock)(UIView *view);

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) BOOL canAdd;

- (void)startEdit;

@end

NS_ASSUME_NONNULL_END
