//
//  StatsReportCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/22.
//

#import "StatsReportCell.h"

@interface StatsReportCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;


@end

@implementation StatsReportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)update:(StatsReportModel *)report row:(NSInteger)row
{
    self.titleLabel.text = [NSString stringWithFormat:@"%li.%@：%@", row+1 , report.title, report.content?:@""];
    
    if (!report.record && report.tip.length == 0) {
        self.tipLabel.hidden = YES;
        
    }else {
        self.tipLabel.hidden = NO;
        
        //已标签为主
        if (report.record) {
            NSString *tagName = report.record.tagModel.name;
            tagName = [NSString stringWithFormat:@"标签：%@", (tagName.length > 0 ? tagName : @"无")];
            self.tipLabel.text = tagName;
            
        }else {
            self.tipLabel.text = report.tip;
        }
    }
}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 220, kSRCellH)];
        _titleLabel.font = SCFONT_SIZED(16);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        CGFloat w = 120;
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-w, 0, w, kSRCellH)];
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = SCFONT_SIZED(11);
        _tipLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end
