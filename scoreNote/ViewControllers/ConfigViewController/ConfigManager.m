//
//  ConfigManager.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "ConfigManager.h"

#define kLineHeight  @"ConfigLineHeight"
#define kLineWidth   @"ConfigLineWidth"
#define kLineFontNum @"ConfigLineFontNum"
#define kLineProfit  @"ConfigLineProfit"
#define kLineInputH  @"ConfigLineInputH"

@interface ConfigManager ()
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat lineFontNum;
@property (nonatomic, assign) CGFloat lineProfit;
@property (nonatomic, assign) CGFloat lineInputH;

@end

@implementation ConfigManager
@synthesize lineWidth = _lineWidth;
@synthesize lineHeight = _lineHeight;
@synthesize lineFontNum = _lineFontNum;
@synthesize lineProfit = _lineProfit;
@synthesize lineInputH = _lineInputH;

DEF_SINGLETON(ConfigManager)

//根据类型赋值
+ (void)setValue:(CGFloat)value type:(ConfigType)type
{
    ConfigManager *manager = [ConfigManager sharedInstance];
    switch (type) {
        case ConfigTypeLineWidth:
            manager.lineWidth = value;
            break;
            
        case ConfigTypeLineHeight:
            manager.lineHeight = value;
            break;
            
        case ConfigTypeLineFont:
            manager.lineFontNum = value;
            break;
            
        case ConfigTypeLineProfit:
            manager.lineProfit = value;
            break;
            
        case ConfigTypeLineInputH:
            manager.lineInputH = value;
            break;
            
        default:
            break;
    }
    
}

//根据类型取值
+ (CGFloat)getValue:(ConfigType)type
{
    ConfigManager *manager = [ConfigManager sharedInstance];
    switch (type) {
        case ConfigTypeLineWidth:
            return manager.lineWidth;
            
        case ConfigTypeLineHeight:
            return manager.lineHeight;
            
        case ConfigTypeLineFont:
            return manager.lineFontNum;
            
        case ConfigTypeLineProfit:
            return manager.lineProfit;
            
        case ConfigTypeLineInputH:
            return manager.lineInputH;
            
        default:
            return 0;
    }
}


- (CGFloat)lineWidth
{
    if (_lineWidth > 0) {
        return _lineWidth;
    }
    
    _lineWidth = [[NSUserDefaults standardUserDefaults] floatForKey:kLineWidth];
    
    if (_lineWidth > 0) {
        return _lineWidth;
    }
    
    self.lineWidth = 110;
    return _lineWidth;
    
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if (lineWidth == _lineWidth) {
        return;
    }
    _lineWidth = lineWidth;
    [[NSUserDefaults standardUserDefaults] setFloat:lineWidth forKey:kLineWidth];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)lineHeight
{
    if (_lineHeight > 0) {
        return _lineHeight;
    }
    
    _lineHeight = [[NSUserDefaults standardUserDefaults] floatForKey:kLineHeight];
    
    if (_lineHeight > 0) {
        return _lineHeight;
    }
    
    self.lineHeight = 25;
    return _lineHeight;
    
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    if (lineHeight == _lineHeight) {
        return;
    }
    _lineHeight = lineHeight;
    [[NSUserDefaults standardUserDefaults] setFloat:lineHeight forKey:kLineHeight];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)lineFontNum
{
    if (_lineFontNum > 0) {
        return _lineFontNum;
    }
    
    _lineFontNum = [[NSUserDefaults standardUserDefaults] floatForKey:kLineFontNum];
    
    if (_lineFontNum > 0) {
        return _lineFontNum;
    }
    
    self.lineFontNum = 13;
    return _lineFontNum;
    
}

- (void)setLineFontNum:(CGFloat)lineFontNum
{
    if (lineFontNum == _lineFontNum) {
        return;
    }
    
    _lineFontNum = lineFontNum;
    [[NSUserDefaults standardUserDefaults] setFloat:lineFontNum forKey:kLineFontNum];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)lineProfit
{
    if (_lineProfit > 0) {
        return _lineProfit;
    }
    
    _lineProfit = [[NSUserDefaults standardUserDefaults] floatForKey:kLineProfit];
    
    if (_lineProfit > 0) {
        return _lineProfit;
    }
    
    self.lineProfit = 50;
    return _lineProfit;
}

- (void)setLineProfit:(CGFloat)lineProfit
{
    if (lineProfit == _lineProfit) {
        return;
    }
    
    _lineProfit = lineProfit;
    [[NSUserDefaults standardUserDefaults] setFloat:lineProfit forKey:kLineProfit];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)lineInputH
{
    if (_lineInputH > 0) {
        return _lineInputH;
    }
    
    _lineInputH = [[NSUserDefaults standardUserDefaults] floatForKey:kLineInputH];
    
    if (_lineInputH > 0) {
        return _lineInputH;
    }
    
    self.lineInputH = IS_LARGE_SCREEN ? 300 : 250;
    
    return _lineInputH;
}

- (void)setLineInputH:(CGFloat)lineInputH
{
    if (lineInputH == _lineInputH) {
        return;
    }
    
    _lineInputH = lineInputH;
    [[NSUserDefaults standardUserDefaults] setFloat:lineInputH forKey:kLineInputH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
