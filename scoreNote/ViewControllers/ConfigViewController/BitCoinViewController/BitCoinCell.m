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
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) BitCoinModel *model;
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
    _model = model;
    
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
    
    self.datePicker.date = model.date;
}

#pragma mark -action
- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    NSDate *pickDate = sender.date;
    
    self.dateLabel.text = [pickDate getStringWithDateFormat:@"yyyy-MM-dd"];
    self.model.date     = pickDate;
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
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.transactionLabel.right+10, 0, 120, kBCCellH)];
        _moneyLabel.font = SCFONT_SIZED(20);
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        CGFloat w = 180;
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-w, 0, w, kBCCellH)];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.font = SCFONT_SIZED(13);
        _dateLabel.backgroundColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        CGFloat w = 200;
        CGFloat h = 40;
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-w-20, (kBCCellH-h)/2, w, h)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        // ========== 可选：限制选择时间范围 ==========
        // 最小可选时间：当前时间
        // self.datePicker.minimumDate = [NSDate date];
        // 最大可选时间：当前时间往后30天
//         self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:30 * 24 * 60 * 60];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0];
        // 4. 添加值改变监听
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.contentView addSubview:_datePicker];
        [self.contentView insertSubview:_datePicker belowSubview:self.dateLabel];
    }
    return _datePicker;
}

@end
