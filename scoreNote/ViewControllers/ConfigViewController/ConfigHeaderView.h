//
//  ConfigHeaderView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kConfigHeaderH  40
#define kConfigHeaderId @"kConfigHeaderId"

@interface ConfigHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
