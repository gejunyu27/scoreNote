//
//  SwitchYearView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/17.
//

#import <UIKit/UIKit.h>
#import "YearModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SwitchYearViewDelegate <NSObject>

- (void)switchYearViewSelected:(NSInteger)index;

@end

@interface SwitchYearView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id <SwitchYearViewDelegate> delegate;

- (void)refresh:(NSArray <YearModel *>*)yearModels;


@end

NS_ASSUME_NONNULL_END
