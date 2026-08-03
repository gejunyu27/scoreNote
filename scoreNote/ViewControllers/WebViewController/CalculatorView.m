//
//  CalculatorView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/3.
//

#import "CalculatorView.h"

@interface CalculatorView ()
@property (nonatomic, strong) UIButton *oddsOneButton;
@property (nonatomic, strong) UIButton *oddsTwoButton;
@property (nonatomic, strong) UIButton *planButton;
@property (nonatomic, strong) UIButton *resultButton;
@end

@implementation CalculatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 8;
    
    CGFloat labelW = self.width/4;
    NSArray *labelArr = @[@"赔率1", @"赔率2", @"计划利润", @"所需投注"];
    
    for (int i=0; i<labelArr.count; i++) {
        NSString *name = labelArr[i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelW*i, 0, labelW, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = SCFONT_SIZED(14);
        label.text = name;
        [self addSubview:label];
        
        CGFloat btnY = label.bottom;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnY, labelW-25, self.height-btnY-10)];
        btn.centerX = label.centerX;
        [self addSubview:btn];
        
        if (i==labelArr.count-1) { //结果
            btn.titleLabel.font = SCFONT_SIZED(18);
            [btn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
            _resultButton = btn;
            
        }else {
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = SCFONT_SIZED(14);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            @weakify(self)
            [btn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
                @strongify(self)
                [self btnClicked:btn title:name];
            }];
            
            if (i==0) { //赔率1
                _oddsOneButton = btn;
            }else if (i==1) { //赔率2
                _oddsTwoButton = btn;
            }else if (i==2) { //计划利润
                _planButton = btn;
            }
             
        }
    }
}

#pragma mark -action
- (void)clear
{
    [_oddsOneButton setTitle:nil forState:UIControlStateNormal];
    [_oddsTwoButton setTitle:nil forState:UIControlStateNormal];
    [_planButton setTitle:nil forState:UIControlStateNormal];
    [_resultButton setTitle:nil forState:UIControlStateNormal];
}

- (void)btnClicked:(UIButton *)sender title:(NSString *)title
{
    [NumberInputView showWithText:sender.currentTitle title:title clickView:sender type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        [sender setTitle:outputText forState:UIControlStateNormal];
        [self startCalculateResult];
    }];
}

- (void)startCalculateResult
{
    //检查完整性
    CGFloat oddsOne = _oddsOneButton.currentTitle.floatValue;
    CGFloat oddsTwo = _oddsTwoButton.currentTitle.floatValue;
    CGFloat plan    = _planButton.currentTitle.floatValue;
    
    if (oddsOne > 1 && oddsTwo > 1 && plan > 0) {
        CGFloat odds = oddsOne*oddsTwo; //3*4=12 标识1块钱中了能收回12
        CGFloat result = plan/(odds-1);
        [_resultButton setTitle:[SCUtilities removeFloatSuffix:result] forState:UIControlStateNormal];
        
    }else {
        [_resultButton setTitle:@"" forState:UIControlStateNormal];
    }
}


@end
