//
//  TotalCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/22.
//

#import "TotalCell.h"

@interface TotalCell ()
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@end

@implementation TotalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setRecord:(RecordModel *)record
{
    _record = record;
    
    self.profitLabel.text = [NSString stringWithFormat:@"%@",[SCUtilities removeFloatSuffix:record.allProfit]];
    self.profitLabel.textColor = record.allProfit > 0 ? [UIColor redColor] : [UIColor blackColor];
    
    NSString *tagName = record.overTagName.length > 0 ? record.overTagName : record.tagModel.name;
    tagName = tagName.length > 0 ? tagName : @"无";
    self.tagLabel.text = tagName;
    
    self.numLabel.text = [NSString stringWithFormat:@"%li期", record.realNum];
}

#pragma mark -ui

#define kMargin 20
- (UILabel *)profitLabel
{
    if (!_profitLabel) {
        _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, 120, kTotalCellH)];
        _profitLabel.font = SCFONT_SIZED(24);
        [self.contentView addSubview:_profitLabel];
    }
    return _profitLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        CGFloat w = 30;
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-kMargin-w, 0, w, kTotalCellH)];
        _numLabel.font = SCFONT_SIZED(10);
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_numLabel];
    }
    return _numLabel;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        CGFloat w = 80;
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.numLabel.left-5-w, 0, w, kTotalCellH)];
        _tagLabel.textAlignment = NSTextAlignmentRight;
        _tagLabel.font = self.numLabel.font;
        _tagLabel.textColor = self.numLabel.textColor;
        [self.contentView addSubview:_tagLabel];
    }
    return _tagLabel;
}



@end


