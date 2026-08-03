//
//  WebNaviBar.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WebNaviBarDelegate <NSObject>

- (void)webNaviBarSelectIndex:(NSInteger)index;

@end

@interface WebNaviBar : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id <WebNaviBarDelegate> delegate;

- (void)createButtonsWithTitleList:(NSArray <NSString *> *)titleList selectedColor:(UIColor *)selectedColor;

@end

NS_ASSUME_NONNULL_END
