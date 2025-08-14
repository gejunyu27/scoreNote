//
//  SCToolBar.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/26.
//

#import "SCToolBar.h"

@interface SCToolBar ()
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UITextField *textField;

@end

@implementation SCToolBar

//通用
+ (void)addBarIn:(UIView *)view titles:(nonnull NSArray<NSString *> *)titles
{
    if (!view || titles.count == 0 || (![view isKindOfClass:UITextView.class] && ![view isKindOfClass:UITextField.class])) {
        return;
    }
    
    SCToolBar *bar = [[SCToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) titles:titles];
    
    if ([view isKindOfClass:UITextField.class]) {
        bar.textField = (UITextField *)view;
        bar.textField.inputAccessoryView = bar;
    } else {
        bar.textView = (UITextView *)view;
        bar.textView.inputAccessoryView = bar;
    }

}

+ (void)addNoteBarInTextView:(UITextView *)textView
{
    [self addBarIn:textView titles:@[@"清空", @"让", @"平", @"胜", @"负"]];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createButtons:titles];
    }
    return self;
}

- (void)createButtons:(NSArray <NSString *> *)titles
{
    CGFloat w = self.width/titles.count;
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(w*i, 0, w, self.height)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = SCFONT_SIZED(15);
        
        NSString *title = titles[i];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        if ([title isEqualToString:@"清空"] || [title isEqualToString:@"清除"] || [title isEqualToString:@"clean"]) {
            [btn addTarget:self action:@selector(cleanClicked) forControlEvents:UIControlEventTouchUpInside];
            
        }else {
            [btn addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)cleanClicked
{
    if (_textView) {
        if (![_textView isFirstResponder]) {
            return;
        }
        
        _textView.text = nil;
        
        return;
    }
    
    if (_textField) {
        if (![_textField isFirstResponder]) {
            return;
        }
        
        _textField.text = nil;
    }

}

- (void)editClicked:(UIButton *)sender
{
    if (_textView) {
        if (![_textView isFirstResponder]) {
            return;
        }
        
        NSMutableString *mul = [NSMutableString stringWithString:_textView.text];
        
        [mul appendString:sender.currentTitle];
        
        _textView.text = mul;
        
        return;
    }
    
    if (_textField) {
        if (![_textField isFirstResponder]) {
            return;
        }
        
        NSMutableString *mul = [NSMutableString stringWithString:_textField.text];
        
        [mul appendString:sender.currentTitle];
        
        _textField.text = mul;
    }

}

@end
