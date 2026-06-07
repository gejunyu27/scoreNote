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
@property (nonatomic, strong) UILabel *transactionLabel;
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
- (void)setModel:(BitCoinModel *)model index:(NSInteger)index
{
    self.indexLabel.text = [NSString stringWithFormat:@"%li.", index];
    
    self.moneyLabel.text = model.money;
    
    self.dateLabel.text  = [model.date getStringWithDateFormat:@"yyyy-MM-dd"];
    
    if (model.isRecharge) {
        self.transactionLabel.backgroundColor = HEX_RGB(@"#14C725");
        self.transactionLabel.text = @"充值";
        
    }else {
        self.transactionLabel.backgroundColor = [UIColor redColor];
        self.transactionLabel.text = @"提现";
    }
    
    
}

#pragma mark -ui
- (UILabel *)indexLabel
{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 20, kBCCellH)];
        [self.contentView addSubview:_indexLabel];
    }
    return _indexLabel;
}

- (UILabel *)transactionLabel
{
    if (!_transactionLabel) {
        CGFloat h = 20;
        _transactionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.indexLabel.right, (kBCCellH-h)/2, h*2, h)];
        _transactionLabel.font = SCFONT_SIZED(13);
        _transactionLabel.textColor = [UIColor whiteColor];
        _transactionLabel.textAlignment = NSTextAlignmentCenter;
        _transactionLabel.layer.cornerRadius = 5;
        _transactionLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_transactionLabel];
    }
    return _transactionLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.transactionLabel.right+10, 0, 150, kBCCellH)];
        _moneyLabel.font = SCFONT_SIZED(20);
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
        _dateLabel.font = SCFONT_SIZED(13);
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

@end
