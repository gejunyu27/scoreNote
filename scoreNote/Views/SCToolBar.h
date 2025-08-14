//
//  SCToolBar.h
//  scoreNote
//
//  Created by gejunyu on 2023/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCToolBar : UIToolbar

//笔记
+ (void)addNoteBarInTextView:(UITextView *)textView;

//通用
+ (void)addBarIn:(UIView *)view titles:(NSArray <NSString *>*)titles;

@end

NS_ASSUME_NONNULL_END
