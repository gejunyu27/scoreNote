//
//  TagDetailCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/7/23.
//

#import "TagDetailCell.h"

@interface TagDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (nonatomic, strong) RecordModel *model;

@end

@implementation TagDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(RecordModel *)model row:(NSInteger)row
{
    _model = model;
    
    //利润
    NSString *profitStr = [SCUtilities removeFloatSuffix:model.allProfit];
    NSString *text = [NSString stringWithFormat:@"%li.利润：%@", row+1, profitStr];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    
    [att addAttributes:@{NSForegroundColorAttributeName:(model.allProfit>0?[UIColor redColor]:[UIColor blackColor])} range:[text rangeOfString:profitStr]];
    
    _titleLabel.attributedText = att;
    
    //结束时间
    NSString *endTime = @"进行中";
    if (model.isOver) {
        endTime = [model.endTime getStringWithDateFormat:@"yyyy-MM-dd"];
    }
    
    _dateLabel.text = endTime;
    
    //期数
    _lineLabel.text = [NSString stringWithFormat:@"共%li期", model.lineList.count];
}

@end
