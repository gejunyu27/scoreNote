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
    InputTypeDefault = 0,     //默认，有全部功能
    InputTypeNumber = 1,      //数字键盘，无扩展区，无空格
    InputTypeReduce = 2,      //再上一个基础上 加号变负号
    InputTypeNoSymbol = 3,    //再上一个基础上 负号移除
    InputTypeNoDot = 4        //再上一个基础上 再移除小数点
};

@interface NumberInputView : UIView

+ (void)showWithText:(nullable NSString *)text title:(nullable NSString *)title clickView:(nullable UIView *)clickView type:(InputType)type block:(nullable InputBlock)block;

@end

NS_ASSUME_NONNULL_END
