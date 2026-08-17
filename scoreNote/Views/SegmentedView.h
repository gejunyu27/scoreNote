//
//  SegmentedView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


//代理和block 两种回调方式

typedef void(^SegmentedBlock)(NSInteger index);


@protocol SegmentedViewDelegate <NSObject>

- (void)segmentedViewSelected:(NSInteger)index;

@end


@interface SegmentedView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, weak) id <SegmentedViewDelegate> delegate;
@property (nonatomic, copy) SegmentedBlock selectedBlock;

@property (nonatomic, strong) UIColor *selectedColor; //方块颜色
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) BOOL isCircle; //是否圆角 default:YES

@end

NS_ASSUME_NONNULL_END
