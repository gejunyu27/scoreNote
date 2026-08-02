//
//  TagRankCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/23.
//

#import "TagRankCell.h"
#import "TagRankModel.h"

@interface TagRankCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *profitLabel;

@end

@implementation TagRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setData:(TagRankModel *)model row:(NSInteger)row
{
    //名次决定标题
    NSString *rank;
    if (row == 0) { //第一名
        rank = @"🏅";
        
    }else if (row == 1) { //第二名
        rank = @"🥈";
        
    }else if (row == 2) { //第三名
        rank = @"🥉";
        
    }else {
        rank = [NSString stringWithFormat:@"%li.", row+1];
    }

    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", rank, model.name];
    
    //数量
    self.numberLabel.text = [NSString stringWithFormat:@"共%li单", model.recordList.count];
    
    //利润
    self.profitLabel.text = [NSString stringWithFormat:@"%@", [SCUtilities removeFloatSuffix:model.allProfit]];
    self.profitLabel.textColor = model.allProfit > 0 ? [UIColor redColor] : [UIColor grayColor];
}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, kTRCellH)];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)profitLabel
{
    if (!_profitLabel) {
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right + 10, 0, 110, kTRCellH)];
        _profitLabel.font = SCFONT_SIZED(20);
        [self.contentView addSubview:_profitLabel];
        
    }
    return _profitLabel;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.profitLabel.right + 10, 0, 50, kTRCellH)];
        _numberLabel.font = SCFONT_SIZED(14);
        [self.contentView addSubview:_numberLabel];
    }
    return _numberLabel;
}

@end
