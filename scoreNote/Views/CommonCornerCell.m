//
//  CommonCornerCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "CommonCornerCell.h"
@implementation CommonCornerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _edge = 15;
        _lineMargin = 15;
        
        [self initCommonUI];

    }
    return self;
}

- (void)initCommonUI
{
    //选中效果移除
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //背景色
    self.backgroundColor = [UIColor clearColor];
    
    //内容背景
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    //分割线
    _sepLine = [UIView new];
    _sepLine.backgroundColor = HEX_RGB(@"#E6E6E6");
    [self.contentView addSubview:_sepLine];
}

- (void)updateCornerWithIndex:(NSInteger)index dataCount:(NSInteger)dataCount
{
    if (index < 0 || index >= dataCount) {
        return;
    }
    
    self.sepLine.hidden = NO;
    
    if (index > 0 && index < dataCount-1) { //中间的
        self.contentView.layer.cornerRadius = 0;
        self.contentView.layer.masksToBounds = NO;
        
    }else {
        self.contentView.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
        self.contentView.layer.masksToBounds = YES;
        
        //特殊情况，总共只有一个元素
        if (dataCount == 1) {
            self.contentView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner | kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
            self.sepLine.hidden = YES;
            
        }else if (index == 0) { //第一个
            // 只开启左上、右上圆角
            self.contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        }else if (index == dataCount - 1) {
            //左下、右下角圆角
            self.contentView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
            self.sepLine.hidden = YES;
        }
        
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(_edge, 0, self.width-_edge*2, self.height);
    
    CGFloat lineH = 1;
    self.sepLine.frame = CGRectMake(_lineMargin, self.contentView.height-lineH, self.contentView.width-_lineMargin*2, lineH);

}

@end
