//
//  BitCoinCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/5/25.
//

#import "BitCoinCell.h"
#import "BitCoinModel.h"

@interface BitCoinCell ()
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation BitCoinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -data
- (void)setModel:(BitCoinModel *)model row:(NSInteger)row
{
    self.indexLabel.text = [NSString stringWithFormat:@"%li.", row+1];
    
    self.moneyLabel.text = model.money;
    
    self.dateLabel.text  = [model.date getStringWithDateFormat:@"yyyy-MM-dd"];
    
    
}

#pragma mark -ui
- (UILabel *)indexLabel
{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, kBCCellH)];
        [self.contentView addSubview:_indexLabel];
    }
    return _indexLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indexLabel.right, 0, 200, kBCCellH)];
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        CGFloat w = 200;
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-w, 0, w, kBCCellH)];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

@end
