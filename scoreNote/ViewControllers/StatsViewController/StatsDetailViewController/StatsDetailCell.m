//
//  StatsDetailCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/19.
//

#import "StatsDetailCell.h"

@interface StatsDetailCell ()

@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIView *sepLine;

@end

@implementation StatsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self sepLine];
    }
    return self;
}

- (void)update:(RecordModel *)record isYear:(BOOL)isYear row:(NSInteger)row
{
    //标签
    NSString *tagName = record.tagModel.name;
    tagName = tagName.length > 0 ? tagName : @"无";
    self.tagLabel.text = [NSString stringWithFormat:@"%li.%@", row+1 ,tagName];
    
    //期数
    self.numLabel.text = [NSString stringWithFormat:@"%li期", record.realNum];
    
    //利润
    self.profitLabel.text = [SCUtilities removeFloatSuffix:record.allProfit];
    self.profitLabel.textColor = [UIColor colorWithProfit:record.allProfit];
    
    //ui
    self.contentView.backgroundColor = isYear ? HEX_RGB(@"#F7F8FA") : [UIColor whiteColor];
    
}

#pragma mark -ui
#define kEdge 25
- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, 150, kSDCellH)];
        _tagLabel.textAlignment = NSTextAlignmentLeft;
        _tagLabel.font = SCFONT_SIZED(17);
        _tagLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_tagLabel];
    }
    return _tagLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tagLabel.right, 0, 60, kSDCellH)];
        _numLabel.font = SCFONT_SIZED(15);
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_numLabel];
    }
    return _numLabel;
}

- (UILabel *)profitLabel
{
    if (!_profitLabel) {
        CGFloat w = 100;
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kEdge-w, 0, w, kSDCellH)];
        _profitLabel.font = SCFONT_SIZED(18);
        _profitLabel.textAlignment = NSTextAlignmentRight;
        _profitLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_profitLabel];
    }
    return _profitLabel;
}


- (UIView *)sepLine
{
    if (!_sepLine) {
        CGFloat h = 1;
        CGFloat x = kEdge;
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(x, kSDCellH-h, SCREEN_WIDTH-x*2, h)];
        _sepLine.backgroundColor = HEX_RGB(@"#EEEEEE");
        [self.contentView addSubview:_sepLine];
    }
    return _sepLine;
}


@end
