//
//  FinanceButton.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinanceButton : UIControl
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

- (void)largerSize;
@end

NS_ASSUME_NONNULL_END
