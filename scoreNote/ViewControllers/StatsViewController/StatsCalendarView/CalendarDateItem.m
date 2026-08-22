//
//  CalendarDateItem.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/17.
//

#import "CalendarDateItem.h"

@interface CalendarDateItem ()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *numLabel;
@end

@implementation CalendarDateItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8;
    }
    return self;
}

#pragma mark -data
- (void)setYear:(YearModel *)year
{
    _month = nil;
    _year = year;
    _showYear = YES;
    [self refresh:year.title num:year.allProfit];
}

- (void)setMonth:(MonthModel *)month
{
    _year = nil;
    _month = month;
    _showYear = NO;
    [self refresh:month.title num:month.allProfit];
}

- (void)refresh:(NSString *)dateString num:(CGFloat)num
{
    self.dateLabel.text = dateString;
    self.numLabel.text = [SCUtilities removeFloatSuffix:num];
    
    self.backgroundColor = num>=0 ? HEX_RGB(@"#FAEDEE") : HEX_RGB(@"#E6F5F0");
    self.numLabel.textColor = [UIColor colorWithProfit:num];
}

#pragma mark -ui
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 22)];
        _dateLabel.bottom = self.height/2;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = SCFONT_SIZED(15);
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        CGFloat x = 2;
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, self.width-x*2, 22)];
        _numLabel.top = self.height/2;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = SCFONT_BOLD_SIZED(15);
        _numLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_numLabel];
    }
    return _numLabel;
}

@end
