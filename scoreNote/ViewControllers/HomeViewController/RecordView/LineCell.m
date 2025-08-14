//
//  LineCell.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/30.
//

#import "LineCell.h"
#import "DataManager.h"

@interface LineCell ()
@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UIButton *getButton;

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation LineCell

- (void)setModel:(LineModel *)model
{
    _model = model;
    
    _outButton.userInteractionEnabled = model;
    _getButton.userInteractionEnabled = model;
    
    [_outButton setTitle:(model ? [SCUtilities removeFloatSuffix:model.outMoney] : @"") forState:UIControlStateNormal];
    [_getButton setTitle:(model.isOver ? [SCUtilities removeFloatSuffix:model.getMoney] : @"") forState:UIControlStateNormal];
    
    _outButton.titleLabel.font = LINE_FONT;
    _getButton.titleLabel.font = LINE_FONT;
    
}

- (void)setIsFirst:(BOOL)isFirst
{
    _topLine.hidden = isFirst;
}

- (void)setCanAdd:(BOOL)canAdd
{
    _addButton.hidden = !canAdd;
}

- (void)startEdit
{
    [self outAction:_outButton];
}

#pragma mark -action
- (IBAction)addAction:(UIButton *)sender {
    if (_addBlock) {
        _addBlock(_outButton);
    }
}

- (IBAction)outAction:(UIButton *)sender {
    //    NSString *text = [sender.titleLabel.text isEqualToString:@"0"] ? @"" : sender.titleLabel.text; //有bug
    NSString *text = self.model.outMoney == 0 ? @"" : [SCUtilities removeFloatSuffix:self.model.outMoney];
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"投入" clickView:sender type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        [sender setTitle:(outputText.length == 0 ? @"0" : outputText) forState:UIControlStateNormal];
        CGFloat money = sender.titleLabel.text.floatValue;
        
        if (money != self.model.outMoney) {
            self.model.outMoney = money;
            [DataManager updateLine:self.model];
            if (self.updateBlock) {
                self.updateBlock(self.model);
            }
        }
        
    }];
}

- (IBAction)getAction:(UIButton *)sender {
    //    NSString *text = [sender.titleLabel.text isEqualToString:@"0"] ? @"" : sender.titleLabel.text; //有bug
    NSString *text = self.model.getMoney == 0 ? @"" : [SCUtilities removeFloatSuffix:self.model.getMoney];
    
    @weakify(self)
    [NumberInputView showWithText:text title:@"收入" clickView:sender type:InputTypeNumber block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        
        CGFloat money = 0;
        
        //是否有加号
        if ([outputText containsString:@"+"]) {
            NSArray *seps = [outputText componentsSeparatedByString:@"+"];
            
            if (seps.count == 2) {
                NSString *outStr = seps.firstObject;
                CGFloat outMoney = [outStr isEqualToString:@""] ? self.model.outMoney : outStr.floatValue;
                
                CGFloat profit = [(NSString *)seps.lastObject floatValue];
                
                money = outMoney + profit;
            }
            
        }else if ([outputText containsString:@"-"]) { //是否有减号
            NSArray *seps = [outputText componentsSeparatedByString:@"-"];
            if (seps.count == 2) {
                NSString *outStr = seps.firstObject;
                CGFloat outMoney = [outStr isEqualToString:@""] ? self.model.outMoney : outStr.floatValue;
                
                CGFloat profit = [(NSString *)seps.lastObject floatValue];
                
                money = outMoney - profit;
            }
            
        } else {
            money = outputText.floatValue;
        }
        
        if (self.model.isOver && money == self.model.getMoney) {
            return;
        }
        
        if (!self.model.isOver) { //有输入就结束
            self.model.isOver = YES;
        }
        
        self.model.getMoney = money;
        
        [DataManager updateLine:self.model];
        if (self.updateBlock) {
            self.updateBlock(self.model);
        }
        
        
    }];
    
}


@end
