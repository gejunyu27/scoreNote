//
//  StatsMonthCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "StatsMonthCell.h"

@interface StatsMonthCell ()
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation StatsMonthCell

#pragma mark -data
- (void)update:(MonthModel *)month index:(NSInteger)index
{
    NSArray *records = month.records;
    
    if (index < 0 || index >= records.count) {
        return;
    }
    
    RecordModel *record = records[index];
    
    //数据
    //标签
    NSString *tagName = record.tagModel.name;
    tagName = tagName.length > 0 ? tagName : @"无";
    self.tagLabel.text = [NSString stringWithFormat:@"%li.%@", index+1 ,tagName];
    
    //期数
    self.numLabel.text = [NSString stringWithFormat:@"%li期", record.realNum];
    //利润
    self.profitLabel.text = [SCUtilities removeFloatSuffix:record.allProfit];
    self.profitLabel.textColor = [UIColor colorWithProfit:record.allProfit];
    
    //UI
    [self updateCornerWithIndex:index dataCount:records.count];
}

#pragma mark -ui
#define kEdge 15
- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, 150, kSMCellH)];
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
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tagLabel.right, 0, 60, kSMCellH)];
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
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-self.edge*2-kEdge-w, 0, w, kSMCellH)];
        _profitLabel.font = SCFONT_SIZED(18);
        _profitLabel.textAlignment = NSTextAlignmentRight;
        _profitLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_profitLabel];
    }
    return _profitLabel;
}



@end
