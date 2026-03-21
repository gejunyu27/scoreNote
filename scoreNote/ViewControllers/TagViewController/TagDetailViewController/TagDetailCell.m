//
//  TagDetailCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/22.
//

#import "TagDetailCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagDetailCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *rowLabel;
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation TagDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString* )reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setRecord:(RecordModel *)record row:(NSInteger)row
{
    //序号
    self.rowLabel.text = [NSString stringWithFormat:@"%li", row+1];
    
    //利润
    NSString *profitStr = [SCUtilities removeFloatSuffix:record.allProfit];
    NSString *text = [NSString stringWithFormat:@"利润：%@", profitStr];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];

    [att addAttributes:@{NSForegroundColorAttributeName:(record.allProfit>0?[UIColor redColor]:[UIColor blackColor])} range:[text rangeOfString:profitStr]];

    self.profitLabel.attributedText = att;

    
    //结束时间
    NSString *endTimeStr = @"进行中";
    if (record.isOver) {
        endTimeStr = [record.endTime getStringWithDateFormat:@"yyyy-MM-dd"];
    }
    
    self.endDateLabel.text = endTimeStr;
//
    //期数
    self.numLabel.text = [NSString stringWithFormat:@"跟%li期", record.lineList.count];
}

#pragma mark -ui
#define kMargin 15
- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat verEdge = 5;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, verEdge, SCREEN_WIDTH-kMargin*2, kTDCellH-verEdge*2)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        [_bgView setCommonShadow];

        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)rowLabel
{
    if (!_rowLabel) {
        _rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, 25, self.bgView.height)];
        _rowLabel.font = SCFONT_SIZED(16);
        [self.bgView addSubview:_rowLabel];
    }
    return _rowLabel;
}

- (UILabel *)profitLabel
{
    if (!_profitLabel) {
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.rowLabel.right, 0, 140, self.bgView.height)];
        _profitLabel.font = SCFONT_SIZED(16);
        [self.bgView addSubview:_profitLabel];
    }
    return _profitLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        CGFloat w = 50;
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.width-kMargin-w, 0, w, self.bgView.height)];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.font = SCFONT_SIZED(14);
        _numLabel.textColor = [UIColor grayColor];
        [self.bgView addSubview:_numLabel];
    }
    return _numLabel;
}

- (UILabel *)endDateLabel
{
    if (!_endDateLabel) {
        CGFloat x = self.profitLabel.right+30;
        _endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, self.numLabel.left-10-x, self.bgView.height)];
        _endDateLabel.textAlignment = NSTextAlignmentRight;
        _endDateLabel.font = _numLabel.font;
        _endDateLabel.textColor = _numLabel.textColor;
        [self.bgView addSubview:_endDateLabel];
    }
    return _endDateLabel;
}

@end

NS_ASSUME_NONNULL_END
