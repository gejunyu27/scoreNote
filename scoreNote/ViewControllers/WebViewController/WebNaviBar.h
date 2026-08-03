//
//  WebNaviBar.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/3.
//

#import <UIKit/UIKit.h>

@protocol WebNaviBarDelegate <NSObject>

- (void)webNaviBarSelectIndex:(NSInteger)index;

@end

@interface WebNaviBar : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id <WebNaviBarDelegate> delegate;

- (void)createButtonsWithTitleList:(nullable NSArray <NSString *> *)titleList selectedColor:(nullable UIColor *)selectedColor;
- (void)createButtonsWithTitleList:(nullable NSArray <NSString *> *)titleList selectedColor:(nullable UIColor *)selectedColor font:(nullable UIFont *)font;

@end

