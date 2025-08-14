//
//  CareerCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/8/3.
//

#import "CareerCell.h"
#import "CareerModel.h"

@interface CareerCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;


@end

@implementation CareerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(CareerModel *)model row:(NSInteger)row
{
    _titleLabel.text = [NSString stringWithFormat:@"%li.%@：%@", row+1 , model.title, model.content];
    
    if (!model.record && model.tip.length == 0) {
        _tipLabel.hidden = YES;
        
    }else {
        _tipLabel.hidden = NO;
        
        //已标签为主
        if (model.record) {
            NSString *tagName = model.record.tagModel.name;
            tagName = [NSString stringWithFormat:@"标签：%@", (tagName.length > 0 ? tagName : @"无")];
            _tipLabel.text = tagName;
            
        }else {
            _tipLabel.text = model.tip;
        }
    }
}


@end
