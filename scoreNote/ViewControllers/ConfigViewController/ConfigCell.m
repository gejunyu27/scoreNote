//
//  ConfigCell.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "ConfigCell.h"

@interface ConfigCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *valueButton;


@end

@implementation ConfigCell

- (void)setType:(ConfigType)type
{
    _type = type;
    
    [_valueButton setTitle:[SCUtilities removeFloatSuffix:[ConfigManager getValue:type]] forState:UIControlStateNormal];
    
    switch (type) {
        case ConfigTypeLineWidth:
            _nameLabel.text = @"格子宽度";
            break;
            
        case ConfigTypeLineHeight:
            _nameLabel.text = @"格子高度";
            break;
            
        case ConfigTypeLineFont:
            _nameLabel.text = @"字体大小";
            break;
            
        case ConfigTypeLineProfit:
            _nameLabel.text = @"默认每期利润";
            break;
            
        case ConfigTypeInputH:
            _nameLabel.text = @"自定键盘高度";
            break;
            
        default:
            break;
    }
}

- (IBAction)resetAction:(UIButton *)sender {
    
    //先赋0
    [ConfigManager setValue:0 type:_type];
    //再显示新值
    [_valueButton setTitle:[SCUtilities removeFloatSuffix:[ConfigManager getValue:_type]] forState:UIControlStateNormal];
    
    if (_updateBlock) {
        _updateBlock();
    }
}

- (IBAction)valueAction:(UIButton *)sender {
    
    CGFloat value = [ConfigManager getValue:_type];
    
    NSString *text = value == 0 ? @"" : [SCUtilities removeFloatSuffix:value];
    
    @weakify(self)
    [NumberInputView showWithText:text title:_nameLabel.text clickView:sender type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        [sender setTitle:outputText forState:UIControlStateNormal];
        
        [ConfigManager setValue:outputText.floatValue type:self.type];
        
        if (self.updateBlock) {
            self.updateBlock();
        }
    }];
}

@end



