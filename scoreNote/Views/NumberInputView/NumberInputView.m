//
//  NumberInputView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/5/7.
//

#import "NumberInputView.h"
#import "InputButton.h"

#define kClear  @"清空"
#define kSpace  @"␣"
#define kDelete @"⌫"
#define kAdd    @"+"
#define kReduce @"-"
#define kDot    @"."

@interface NumberInputView ()
@property (nonatomic, strong) UIView *keyboardView; //键盘区
@property (nonatomic, strong) UILabel *resultLabel; //结果区
@property (nonatomic, strong) UILabel *titleLabel;  //标题区
@property (nonatomic, copy) InputBlock inputBlock; //回调
@property (nonatomic, assign) InputType inputType; //类型

@property (nonatomic, weak) UIView *clickView;
@property (nonatomic, strong) UIColor *clickOriginColor;
@end

@implementation NumberInputView

+ (void)showWithText:(NSString *)text title:(NSString *)title clickView:(UIView *)clickView type:(InputType)type block:(InputBlock)block
{
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    
    UITabBarController *vc = [SCUtilities currentTabBarController];
    
    NumberInputView *view = [[NumberInputView alloc] initWithFrame:vc.view.bounds text:text title:title clickView:clickView type:type block:block];
    
    clickView.backgroundColor = [UIColor greenColor];
    
    [vc.view addSubview:view];
}


- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text title:(NSString *)title clickView:(UIView *)clickView type:(InputType)type block:(InputBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputBlock = block;
        self.inputType = type;
        
        if (clickView) {
            self.clickView = clickView;
            self.clickOriginColor = clickView.backgroundColor;
        }
        
        [self initUIWithText:text title:title];
    }
    return self;
}

- (void)initUIWithText:(NSString *)text title:(NSString *)title
{
    //背景色
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    
    //返回按钮
    UIControl *backControl = [[UIControl alloc] initWithFrame:self.bounds];
    [backControl addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backControl];
    
    //标题
    self.titleLabel.text = title;
    
    //内容
    self.resultLabel.text = text;
}

#pragma mark -action
- (void)backClicked
{
    [self removeFromSuperview];
    
    if (self.clickView) {
        self.clickView.backgroundColor = self.clickOriginColor;
    }
    
    if (_inputBlock) {
        _inputBlock(self.resultLabel.text);
    }
}

- (void)btnClicked:(InputButton *)sender
{
    NSString *input = sender.titleLabel.text;
    
    if (input.length == 0) {
        return;
    }
    
    NSMutableString *text = [NSMutableString stringWithString:self.resultLabel.text?:@""];
    
    /**以下3个判断是暂时为了简化计算的临时方法**/
    if (([input isEqualToString:kAdd] || [input isEqualToString:kReduce]) && ([text containsString:kReduce] || [text containsString:kAdd])) { //加减只能出现一次
        return;
    }
    
    if ([input isEqualToString:kReduce] && text.length > 0) { //负号必须在开头
        return;
    }
    
    if ([input isEqualToString:kDot] && [text containsString:kDot]) { //小数点只能有一个
        return;
    }
    
    /****/
    
    if ([input isEqualToString:kClear]) { //清空
        self.resultLabel.text = nil;
        return;
        
    }
    
    if ([input isEqualToString:kDelete]) { //删除
        if (text.length > 0) {
            [text deleteCharactersInRange:NSMakeRange(text.length-1, 1)];
            self.resultLabel.text = text.copy;
        }
        
        return;
    }
    
    if ([input isEqualToString:kSpace]) { //空格
        input = @" ";
    }
    
    
    [text appendString:input];
    self.resultLabel.text = text.copy;
}

#pragma mark -ui
- (UIView *)keyboardView
{
    if (!_keyboardView) {
        //键盘区
        _keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, LINE_INPUTH)];
        _keyboardView.bottom = self.height;
        _keyboardView.backgroundColor = HEX_RGB(@"#D1D3DA");
        [self addSubview:_keyboardView];
        
        CGFloat margin = SCREEN_FIX(6);
        CGFloat contentH = SCREEN_FIX(210);
        
        //符号
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, SCREEN_FIX(55), contentH)];
        [_keyboardView addSubview:leftView];
        
        CGFloat btnH = (contentH - margin*3)/4;
        NSArray *leftTitles = _inputType == InputTypeDefault ? @[@"让",@"平",@"胜",@"负"] : @[@"",@"",@"",@""];
        for (int i=0; i<leftTitles.count; i++) {
            InputButton *btn = [[InputButton alloc] initWithFrame:CGRectMake(0, (margin + btnH)*i, leftView.width, btnH)];
            btn.originColor = HEX_RGB(@"#B9BBC3");
            [btn setTitle:leftTitles[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [leftView addSubview:btn];
        }
        
        //其它
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, margin, leftView.width, contentH)];
        rightView.right = self.width - margin;
        [_keyboardView addSubview:rightView];
        
        NSString *symbol = kAdd;
        if (_inputType >= InputTypeNoSymbol) {
            symbol = @"";
            
        }else if (_inputType == InputTypeReduce) {
            symbol = kReduce;
        }
        
        NSArray *rightTitles = @[kDelete, (_inputType < InputTypeNoDot ? kDot : @""), symbol, @"完成"];
        for (int i=0; i<rightTitles.count; i++) {
            InputButton *btn = [[InputButton alloc] initWithFrame:CGRectMake(0, (margin + btnH)*i, leftView.width, btnH)];
            NSString *title = rightTitles[i];
            [btn setTitle:title forState:UIControlStateNormal];
            
            if ([title isEqualToString:@"完成"]) {
                btn.originColor = HEX_RGB(@"#ED7041");
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
                
            }else {
                btn.originColor = HEX_RGB(@"#B9BBC3");
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            [rightView addSubview:btn];
        }
        
        //数字
        CGFloat x = leftView.right + margin;
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(x, margin, rightView.left-margin-x, contentH)];
        [_keyboardView addSubview:centerView];
        
        CGFloat btnW = (centerView.width - margin*2)/3;
        NSArray *centerTitles = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",kClear,@"0",(_inputType == InputTypeDefault ? kSpace : @"")];
        for (int i=0; i<4; i++) {
            for (int j=0; j<3; j++) {
                InputButton *btn = [[InputButton alloc] initWithFrame:CGRectMake((btnW+margin)*j, (btnH+margin)*i, btnW, btnH)];
                NSString *title = centerTitles[i*3+j];
                [btn setTitle:title forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.originColor = [UIColor whiteColor];
                [centerView addSubview:btn];
            }
        }
    }
    return _keyboardView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, SCREEN_FIX(40))];
        _titleLabel.bottom = self.keyboardView.top;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = HEX_RGB(@"#F7F7F7");
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)resultLabel
{
    if (!_resultLabel) {
        CGFloat x = SCREEN_FIX(50);
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, self.width-x*2, SCREEN_FIX(60))];
        _resultLabel.bottom = self.titleLabel.top - SCREEN_FIX(40);
        _resultLabel.backgroundColor = [UIColor whiteColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.font = SCFONT_SIZED(25);
        _resultLabel.layer.cornerRadius = SCREEN_FIX(10);
        _resultLabel.layer.borderWidth = 1;
        _resultLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _resultLabel.layer.masksToBounds = YES;
        [self addSubview:_resultLabel];
        
    }
    return _resultLabel;
}

@end


