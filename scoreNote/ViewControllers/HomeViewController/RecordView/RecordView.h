//
//  RecordView.h
//  scoreNote
//
//  Created by gejunyu on 2022/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RecordView;

@protocol RecordViewDelegate <NSObject>

- (void)recordView:(RecordView *)recordView insertNewLineWithRecord:(RecordModel *)record view:(nullable UIView *)view;
- (void)recordView:(RecordView *)recordView overRecord:(RecordModel *)record;
- (void)recordView:(RecordView *)recordView editNote:(NSString *)note record:(RecordModel *)record;
- (void)recordView:(RecordView *)recordView editRecord:(RecordModel *)record;
- (void)recordView:(RecordView *)recordView tagSelect:(RecordModel *)record;
- (void)recordView:(RecordView *)recordView editRealNum:(RecordModel *)record;


@end

@interface RecordView : UIView

@property (nonatomic, weak) id <RecordViewDelegate> delegate;

- (void)refreshUI:(RecordModel *)model title:(NSString *)title maxNum:(NSInteger)maxNum;

- (void)refreshUI;

@end

NS_ASSUME_NONNULL_END
