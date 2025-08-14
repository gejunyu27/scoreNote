//
//  InputButton.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/5/9.
//

#import "InputButton.h"

@implementation InputButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = SCREEN_FIX(5);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

@synthesize originColor = _originColor;

- (UIColor *)originColor
{
    if (!_originColor) {
        _originColor = self.backgroundColor;
    }
    return _originColor;
}

- (void)setOriginColor:(UIColor *)originColor
{
    _originColor = originColor;
    self.backgroundColor = originColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = HEX_RGB(@"#9C9C9C");
    }else {
        self.backgroundColor = self.originColor;
    }
}

@end
