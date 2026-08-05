//
//  NumberInputView.h
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^InputBlock)(NSString *outputText);

typedef NS_ENUM(NSInteger, InputType) {
    InputTypeDefault = 0,     //默认，有全部功能:除基本的数字，清空，完成，退格外，还有让平胜负，空格，小数点，冒号
    InputTypeNumber,          //数字键盘，无让平胜负，无空格, 无冒号
    InputTypeNoDot            //再上一个基础上 再移除小数点
};

@interface NumberInputView : UIView

+ (void)showWithText:(nullable NSString *)text title:(nullable NSString *)title clickView:(nullable UIView *)clickView type:(InputType)type block:(nullable InputBlock)block;

@end

NS_ASSUME_NONNULL_END
