//
//  ConfigFunctionCell.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/3/28.
//

#import "ConfigFunctionCell.h"

@interface ConfigFunctionCell ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation ConfigFunctionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -data
- (void)setModel:(ConfigModel *)model
{
    _model = model;
    
    [self.leftButton setTitle:model.title forState:UIControlStateNormal];
    [self.rightButton setTitle:model.secondTitle forState:UIControlStateNormal];
}


#pragma mark -action
- (void)leftClicked:(UIButton *)sender
{
    if (_model.functionType == ConfigFunctionBitAndDeveloper) {
        if ([self.delegate respondsToSelector:@selector(functionCellPushDeveloper)]) {
            [self.delegate functionCellPushDeveloper];
        }
        
    }else if (_model.functionType == ConfigFunctionData) {
        if ([self.delegate respondsToSelector:@selector(functionCellSaveData)]) {
            [self.delegate functionCellSaveData];
        }
    }
}

- (void)rightClicked:(UIButton *)sender
{
    if (_model.functionType == ConfigFunctionBitAndDeveloper) {
        if ([self.delegate respondsToSelector:@selector(functionCellPushBitCoin)]) {
            [self.delegate functionCellPushBitCoin];
        }

        
    }else if (_model.functionType == ConfigFunctionData) {
        if ([self.delegate respondsToSelector:@selector(functionCellDeleteData)]) {
            [self.delegate functionCellDeleteData];
        }
    }
}

#pragma mark -ui
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftButton.frame = CGRectMake(10, 0, 100, kCFCellH);
        [_leftButton addTarget:self action:@selector(leftClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leftButton];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat w = self.leftButton.width;
        _rightButton.frame = CGRectMake(SCREEN_WIDTH-40-w, 0, w, kCFCellH);
        [_rightButton addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightButton];
    }
    return _rightButton;
}

@end

