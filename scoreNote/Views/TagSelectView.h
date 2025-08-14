//
//  TagSelectView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TagSelectBlock)(TagModel * _Nullable tag);

@interface TagSelectView : UIView

+ (void)show:(TagSelectBlock)selectBlock;

@end

NS_ASSUME_NONNULL_END
