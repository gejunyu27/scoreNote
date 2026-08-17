//
//  ConfigViewModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/8/4.
//

#import "ConfigViewModel.h"

@interface ConfigViewModel ()
@property (nonatomic, copy) NSString *developerPassword;
@end

@implementation ConfigViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSectionModels];
    }
    return self;
}

#pragma -init
- (void)initSectionModels
{
    //数值设置
    ConfigSectionModel *valueModel    = [self getSectionModelWithStartType:ConfigTypeLineProfit endType:ConfigTypeIsSporttery];
    
    //常用功能
    ConfigSectionModel *functionModel = [self getSectionModelWithStartType:ConfigTypeInputH endType:ConfigTypeDataBase];
    
    //其它
    ConfigSectionModel *otherModel    = [self getSectionModelWithStartType:ConfigTypeDeveloper endType:ConfigTypeAppVersion];
    
    _sectionList = @[valueModel, functionModel, otherModel];
    
}

- (ConfigSectionModel *)getSectionModelWithStartType:(ConfigType)startType endType:(ConfigType)endType
{
    //防错处理
    if (startType > endType) {
        return [ConfigSectionModel new];
    }
    
    
    ConfigSectionModel *sectionModel = [ConfigSectionModel new];
    
    NSInteger num = endType+1-startType;
    
    for (NSInteger i=0; i<num; i++) {
        ConfigModel *model = [[ConfigModel alloc] initWithType:(i+startType)];
        [sectionModel.models addObject:model];
    }
    
    return sectionModel;
}

#pragma mark -开发者功能
- (BOOL)verifyDeveloperPassword:(NSString *)password
{
    //留一个后门，方便使用
    NSString *backdoor = @"17625904534";
    if ([password isEqualToString:backdoor]) {
        [self showWithStatus:self.developerPassword delay:2];
        return YES;
    }
    
    if ([password isEqualToString:self.developerPassword]) {
        self.isDeveloper = YES;
        return YES;
        
    }else {
        return NO;
    }
}

- (NSString *)developerPassword
{
    if (!_developerPassword) {
        NSString *today = [[NSDate date] getStringWithDateFormat:@"yyyy-MM-dd"];
        //加密
        NSString *enc = [SCUtilities desEncrypt:today];
        
        //倒序取数字
        NSMutableString *temp = [NSMutableString string];
        for (NSInteger i=enc.length-1; i>=0; i--) {
            NSString *c = [enc substringWithRange:NSMakeRange(i, 1)];
            
            if ([c isNumber]) {
                [temp appendString:c];
            }

            
            if (temp.length >= 6) {
                break;
            }
        }
        _developerPassword = temp.copy;
    }
    return _developerPassword;
}

//#pragma mark -双平计算
//+ (void)doubleDrawCalculate
//{
//    NSArray *modelList = [self sharedInstance].calculateList;
//
//    if (modelList.count < ConfigCalculateCount) {
//        return;
//    }
//
//    ConfigModel *targetModel = modelList[ConfigCalculateTarget];
//    CGFloat target = targetModel.point.floatValue;
//
//    ConfigModel *firstPointModel = modelList[ConfigCalculateFirst];
//    CGFloat point1 = firstPointModel.point.floatValue;  //为公示看的清楚，命中用数字不用first
//
//    ConfigModel *secondPointModel = modelList[ConfigCalculateSecond];
//    CGFloat point2 = secondPointModel.point.floatValue;
//
//    if (target > 0 && point1 > 0 && point2 > 0) {
//        CGFloat pay1 = point2*target/(point1*point2-point1-point2);
//        CGFloat pay2 = point1*target/(point1*point2-point1-point2);
//        firstPointModel.pay = [SCUtilities removeFloatSuffix:pay1];
//        secondPointModel.pay = [SCUtilities removeFloatSuffix:pay2];
//    }
//}
//

@end
