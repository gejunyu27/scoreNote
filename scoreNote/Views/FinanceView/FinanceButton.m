//
//  FinanceButton.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import "FinanceButton.h"

@interface FinanceButton ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

//数字动画
@property (nonatomic, strong) CADisplayLink *countDisplayLink;
@property (nonatomic, assign) double animationFromValue;
@property (nonatomic, assign) double animationToValue;
@property (nonatomic, assign) NSTimeInterval animationStartTime;
@property (nonatomic, assign) BOOL hasAnimated; //是否已经显示过动画
@end

@implementation FinanceButton

- (void)largerSize
{
//    self.titleLabel.textColor = HEX_RGB(@"#797979");
    self.titleLabel.font = SCFONT_SIZED(13);
    self.contentLabel.font = SCFONT_BOLD_SIZED(28);
}

#pragma mark -data
- (void)setModel:(FinanceModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    
    BOOL isNum = [model.content isNumber];
    CGFloat num = model.content.floatValue;
    
    if (model.showAnimation && isNum & !_hasAnimated) {
        _hasAnimated = YES; //只在进入时显示一次
        [self startCountAnimationFrom:0 to:num duration:4];
        
    }else {
        self.contentLabel.text = model.content;
    }

    
    if (model.changeColor && isNum) {
        self.contentLabel.textColor = [UIColor colorWithProfit:num];
        
    }else {
        self.contentLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark -animation
- (void)startCountAnimationFrom:(double)from to:(double)to duration:(NSTimeInterval)duration {
    if (self.countDisplayLink) {
        [self.countDisplayLink invalidate];
        self.countDisplayLink = nil;
    }
    if (to == 0) {
        self.contentLabel.text = @"0";
        return;
    }
    
    self.animationFromValue = from;
    self.animationToValue = to;
    self.animationStartTime = CACurrentMediaTime();
    
    __weak typeof(self) weakSelf = self;
    self.countDisplayLink = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(countTick:)];

    self.countDisplayLink.preferredFramesPerSecond = 60;
    
    [self.countDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)countTick:(CADisplayLink *)link {
    NSTimeInterval elapsed = CACurrentMediaTime() - self.animationStartTime;
    double progress = MIN(elapsed / 0.7, 1.0);
    // easeOut缓动
    double easeOutProgress = 1 - pow((1 - progress), 3);
    double current = self.animationFromValue + (self.animationToValue - self.animationFromValue) * easeOutProgress;
    
    self.contentLabel.text = [SCUtilities removeFloatSuffix:current];
    
    if (progress >= 1.0) {
        self.contentLabel.text = [SCUtilities removeFloatSuffix:self.animationToValue];
        [link invalidate];
        self.countDisplayLink = nil;
    }
}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        _titleLabel.textColor = HEX_RGB(@"#9F9F9F");
        _titleLabel.font = SCFONT_SIZED(12);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        CGFloat h = self.height - self.titleLabel.bottom;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-h, self.width, h)];
        _contentLabel.font = SCFONT_SIZED(16);
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (void)dealloc
{
    [_countDisplayLink invalidate];
}

@end
