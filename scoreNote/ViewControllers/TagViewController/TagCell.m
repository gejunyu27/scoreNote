//
//  TagCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/26.
//

#import "TagCell.h"

@interface TagCell () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *maxNumButton;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation TagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -ui
- (void)setModel:(TagModel *)model
{
    _model = model;
    self.nameField.text = model.name;
    [self.maxNumButton setTitle:[NSString stringWithFormat:@"%li",model.maxCount] forState:UIControlStateNormal];
    
    //编辑状态
    BOOL isEdit = model.isEdit;
    
    [self.editButton setImage:(isEdit ? [UIImage imageNamed:@"TagEditSelected"] : [UIImage imageNamed:@"TagEdit"]) forState:UIControlStateNormal];
    
    self.maxNumButton.userInteractionEnabled = isEdit;
    
    self.deleteButton.hidden = !isEdit;
    
    self.nameField.left = isEdit ? self.deleteButton.right + 5 : self.deleteButton.left;
    self.nameField.width = self.numLabel.left - 20 - self.nameField.left;
    self.nameField.userInteractionEnabled = isEdit;
    
}

#pragma mark -action
- (void)maxCountClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(tagCellEditMaxCount:clickView:)]) {
        [self.delegate tagCellEditMaxCount:_model clickView:sender];
    }
    
}

- (void)editClicked:(UIButton *)sender
{
    _model.isEdit ^= 1;
    self.model = _model;
}

- (void)deleteClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(tagCellDelete:)]) {
        [self.delegate tagCellDelete:_model];
    }
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.text.length == 0) {
        textField.text = _model.name;
        return;
        
    }else if ([textField.text isEqualToString:_model.name]) {
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


#pragma mark -ui
- (UIButton *)editButton
{
    if (!_editButton) {
        CGFloat wh = 25;
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-wh-30, (kTagCellH-wh)/2, wh, wh)];
        [_editButton addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_editButton];
    }
    return _editButton;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        CGFloat wh = self.editButton.width;
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (kTagCellH-wh)/2, wh, wh)];
        [_deleteButton addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"TagDelete"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteButton];
    }
    return _deleteButton;
}

- (UIButton *)maxNumButton
{
    if (!_maxNumButton) {
        CGFloat y = 5;
        CGFloat w = 35;
        _maxNumButton = [[UIButton alloc] initWithFrame:CGRectMake(self.editButton.left-15-w, y, w, kTagCellH-y*2)];
        _maxNumButton.titleLabel.font = SCFONT_SIZED(13);
        _maxNumButton.layer.cornerRadius = 4;
        _maxNumButton.layer.borderWidth = 1;
        [_maxNumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _maxNumButton.layer.borderColor = HEX_RGB(@"#F2F2F2").CGColor;
        [_maxNumButton addTarget:self action:@selector(maxCountClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_maxNumButton];
    }
    return _maxNumButton;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        CGFloat w = 45;
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.maxNumButton.left-w, 0, w, kTagCellH)];
        _numLabel.font = SCFONT_SIZED(11);
        _numLabel.text = @"最大期：";
        [self.contentView addSubview:_numLabel];
    }
    return _numLabel;
}


- (UITextField *)nameField
{
    if (!_nameField) {
        CGFloat y = self.maxNumButton.top;
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, y, 0, kTagCellH-y*2)];
        _nameField.returnKeyType = UIReturnKeyDone;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.font = SCFONT_SIZED(16);
        _nameField.borderStyle = UITextBorderStyleRoundedRect;
        _nameField.delegate = self;
        [self.contentView addSubview:_nameField];
        
    }
    return _nameField;
}



@end

