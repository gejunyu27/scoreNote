//
//  FinanceView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import "FinanceView.h"
#import "FinanceButton.h"

@interface FinanceView ()
@property (nonatomic, strong) NSArray <FinanceButton *> *financeButtonList;
@property (nonatomic, strong) NSMutableArray <UIButton *> *functionButtonList;
@end

@implementation FinanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        [self setCommonShadow];
    }
    return self;
}

- (void)setModels:(NSArray<FinanceModel *> *)models
{
    _models = models;
    
    if (models.count == 0) {
        return;
    }
    
    if (!_financeButtonList) {
        [self initUI];
    }
    
    [models enumerateObjectsUsingBlock:^(FinanceModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.financeButtonList.count) {
            FinanceButton *btn = self.financeButtonList[idx];
            btn.title   = model.title;
            btn.content = model.content;
        }
    }];
    
}

- (void)initUI
{
    NSInteger count = self.models.count;
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:count];
    
    CGFloat horEdge = 15;
    FinanceButton *headerButton = [[FinanceButton alloc] initWithFrame:CGRectMake(horEdge, 15, 200, 50)];
    [headerButton largerSize];
    [self addSubview:headerButton];
    
    [temp addObject:headerButton];
    
    //1排两个，剩下按钮占几排
    NSInteger lines = (count-1)/2;
    CGFloat btnH = 40;
    CGFloat verEdge = 5;
    CGFloat y = self.height - btnH*lines - verEdge*lines;
    CGFloat w = (self.width-horEdge*2)/2;
    
    for (int i=0; i<count-1; i++) {
        FinanceButton *btn = [[FinanceButton alloc] initWithFrame:CGRectMake(horEdge+w*(i%2), y+(btnH+verEdge)*(i/2), w, btnH)];
        [self addSubview:btn];
        [temp addObject:btn];
    }
    
    _financeButtonList = temp.copy;
    
    //下划线
    if (lines > 0) {
        CGFloat lineH = 0.5;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(horEdge, y-10-lineH, self.width-horEdge*2, lineH)];
        line.backgroundColor = HEX_RGB(@"#F1F1F1");
        [self addSubview:line];
    }
}

//添加右侧按钮 写法1
- (void)addFunctionButtonWithImage:(id)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *btn = [self addFunctionButtonWithImage:image];
    [btn addTarget:target action:action forControlEvents:controlEvents];

}

//添加右侧按钮 写法2
- (void)addFunctionButtonWithImage:(id)image eventHandler:(nonnull void (^)(id _Nonnull))handler
{
    UIButton *btn = [self addFunctionButtonWithImage:image];
    [btn sc_addEventTouchUpInsideHandle:handler];
}

- (UIButton *)addFunctionButtonWithImage:(id)image
{
    CGFloat btnWH   = 30;
    CGFloat btnEdge = 20;
    
    //第几个按钮
    NSInteger index = self.functionButtonList.count;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - (btnEdge+btnWH)*(index+1), 25, btnWH, btnWH)];
    
    if ([image isKindOfClass:UIImage.class]) {
        [btn setImage:image forState:UIControlStateNormal];
        
    }else if ([image isKindOfClass:NSString.class]) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [self addSubview:btn];
    [self.functionButtonList addObject:btn];
    
    return btn;
}

- (NSMutableArray<UIButton *> *)functionButtonList
{
    if (!_functionButtonList) {
        _functionButtonList = [NSMutableArray array];
    }
    return _functionButtonList;
}

@end
