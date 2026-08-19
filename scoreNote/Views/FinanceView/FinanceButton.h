//
//  FinanceButton.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import <UIKit/UIKit.h>
#import "FinanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinanceButton : UIControl
@property (nonatomic, strong) FinanceModel *model;

- (void)largerSize;
@end

NS_ASSUME_NONNULL_END
