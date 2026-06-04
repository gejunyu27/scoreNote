//
//  FinanceView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/4.
//

#import "FinanceView.h"
#import "FinanceButton.h"

@interface FinanceView ()
@property (nonatomic, strong) NSArray *buttonList;
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
    
    if (!_buttonList) {
        [self initUI];
    }
    
    [models enumerateObjectsUsingBlock:^(FinanceModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.buttonList.count) {
            FinanceButton *btn = self.buttonList[idx];
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
    
    _buttonList = temp.copy;
    
    //下划线
    if (lines > 1) {
        CGFloat lineH = 0.5;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(horEdge, y-10-lineH, self.width-horEdge*2, lineH)];
        line.backgroundColor = HEX_RGB(@"#F1F1F1");
        [self addSubview:line];
    }
}


@end
