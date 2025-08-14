//
//  TagCell.m
//  scoreNote
//
//  Created by gejunyu on 2023/5/1.
//

#import "TagCell.h"
#import "SCToolBar.h"

@interface TagCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *maxCountButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@end

@implementation TagCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _maxCountButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
}

- (void)setModel:(TagModel *)model
{
    _model = model;
    _nameTF.text = model.name;
    [_maxCountButton setTitle:[NSString stringWithFormat:@"%li",model.maxCount] forState:UIControlStateNormal];
    
    if (model.isEdit) {
        [_editButton setTitle:@"编辑中" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
    }else {
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    _nameTF.userInteractionEnabled = model.isEdit;
    _maxCountButton.userInteractionEnabled = model.isEdit;
    
}

#pragma mark -action
- (IBAction)maxCountAction:(UIButton *)sender {
    
    NSString *text = self.model.maxCount == 0 ? @"" : [NSString stringWithFormat:@"%li",self.model.maxCount];
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"最大期" clickView:sender type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        NSInteger num = [outputText integerValue];
        [sender setTitle:[NSString stringWithFormat:@"%li", num] forState:UIControlStateNormal];
        if (num != self.model.maxCount) {
            if ([self.delegate respondsToSelector:@selector(tagCellEditMaxCount:model:)]) {
                [self.delegate tagCellEditMaxCount:num model:self.model];
            }
        }
        
    }];
    
}

- (IBAction)editAction:(UIButton *)sender {
    _model.isEdit ^= 1;
    self.model = _model;
}


#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.text.length == 0) {
        textField.text = _model.name;
        return;
    }
    if ([self.delegate respondsToSelector:@selector(tagCellEditName:model:)]) {
        [self.delegate tagCellEditName:textField.text model:self.model];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
