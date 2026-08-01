//
//  SportteryView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SportteryDelegate <NSObject>

- (void)sportteryCloseClicked;

@end

//中国竞彩网
@interface SportteryView : UIView

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, weak) id <SportteryDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
