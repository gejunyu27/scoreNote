//
//  CommonHeaderView.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/4.
//

#import "CommonHeaderView.h"
#import "TotalSectionModel.h"

@interface  CommonHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIControl *control;
@end

@implementation CommonHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = HEX_RGB(@"#EFEFF2");
        @weakify(self)
        [self.control sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.clickBlock) {
                self.clickBlock();
            }
        }];
    }
    return self;
}


#pragma mark -data
- (void)setTotalSection:(TotalSectionModel *)model
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@    共%li单", (model.isOn ? @"▼" : @"▶︎"),model.name, model.recordList.count]; ;

    self.detailLabel.text =[NSString stringWithFormat:@"总计：%@", [SCUtilities removeFloatSuffix:model.allProfit]];
}

- (void)setSqlRecord:(RecordModel *)record section:(NSInteger)section
{
    NSString *title = [NSString stringWithFormat:@"%li.编号：%@", section+1, record.recordId];
    self.titleLabel.text = title;
 
    NSString *tagName = record.tagModel.name;
    tagName = [NSString stringWithFormat:@"标签：%@", (tagName.length>0 ? tagName : @"无")];
    self.tipLabel.text = tagName;
    
    
}

- (void)setSqlLine:(LineModel *)line section:(NSInteger)section
{
    NSString *title = [NSString stringWithFormat:@"%li.编号：%@", section+1, line.lineId];
    self.titleLabel.text = title;
}

#pragma mark -ui
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, kCommonHeaderH)];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        CGFloat x = self.titleLabel.right;
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH-x, kCommonHeaderH)];
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        CGFloat w = 105;
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-w-10, 0, w, kCommonHeaderH)];
        _detailLabel.font = SCFONT_SIZED(12);
        _detailLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIControl *)control
{
    if (!_control) {
        _control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCommonHeaderH)];
        [self.contentView addSubview:_control];
    }
    return _control;
}

@end
