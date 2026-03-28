//
//  ConfigManager.m
//  scoreNote
//
//  Created by gejunyu on 2023/10/29.
//

#import "ConfigManager.h"
#import "ConfigHeaderModel.h"

@interface ConfigManager ()
@property (nonatomic, strong) NSArray <ConfigModel *> *calculateList; //计算
@property (nonatomic, strong) NSArray <ConfigModel *> *commonList;    //常用
@property (nonatomic, assign) BOOL isDeveloper;
@property (nonatomic, copy) NSString *developerPassword;

@end

@implementation ConfigManager
DEF_SINGLETON(ConfigManager)

#pragma mark -获取数据
+ (NSArray<ConfigHeaderModel *> *)getConfigHeaderList
{
    ConfigManager *manager = [self sharedInstance];
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i=0; i<ConfigHeaderTypeCount; i++) {
        
        ConfigHeaderModel *headerModel;
        if (i==ConfigHeaderTypeCalcalte) {
            headerModel = [[ConfigHeaderModel alloc] initWithType:i list:manager.calculateList];
            
        }else if (i == ConfigHeaderTypeCommon) {
            headerModel = [[ConfigHeaderModel alloc] initWithType:i list:manager.commonList];
            
        }else {
            headerModel = [[ConfigHeaderModel alloc] initWithType:i list:manager.functionList];
        }
        
        [temp addObject:headerModel];
    }
    
    return temp.copy;
}

- (NSArray<ConfigModel *> *)calculateList
{
    if (!_calculateList) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i=0; i<ConfigCalculateCount; i++) {
            ConfigModel *model = [[ConfigModel alloc] initWithCalculateType:i];
            [temp addObject:model];
        }
        _calculateList = temp.copy;
    }
    return _calculateList;
}

- (NSArray<ConfigModel *> *)commonList
{
    if (!_commonList) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i=0; i<ConfigTypeCount; i++) {
            ConfigModel *model = [[ConfigModel alloc] initWithConfigType:i];
            [temp addObject:model];
        }
        _commonList = temp.copy;
    }
    return _commonList;
}

- (NSArray<ConfigModel *> *)functionList
{
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<ConfigFunctionCount; i++) {
        ConfigModel *model = [[ConfigModel alloc] initWithFunctionType:i];
        [temp addObject:model];
    }
    
    return temp.copy;
}


//双平计算
+ (void)doubleDrawCalculate
{
    NSArray *modelList = [self sharedInstance].calculateList;
    
    if (modelList.count < ConfigCalculateCount) {
        return;
    }
    
    ConfigModel *targetModel = modelList[ConfigCalculateTarget];
    CGFloat target = targetModel.point.floatValue;
    
    ConfigModel *firstPointModel = modelList[ConfigCalculateFirst];
    CGFloat point1 = firstPointModel.point.floatValue;  //为公示看的清楚，命中用数字不用first
    
    ConfigModel *secondPointModel = modelList[ConfigCalculateSecond];
    CGFloat point2 = secondPointModel.point.floatValue;

    if (target > 0 && point1 > 0 && point2 > 0) {
        CGFloat pay1 = point2*target/(point1*point2-point1-point2);
        CGFloat pay2 = point1*target/(point1*point2-point1-point2);
        firstPointModel.pay = [SCUtilities removeFloatSuffix:pay1];
        secondPointModel.pay = [SCUtilities removeFloatSuffix:pay2];
    }
}

//根据类型取值
+ (CGFloat)getValue:(ConfigType)type
{
    NSArray *models = [[self sharedInstance] commonList];
    
    if (models.count < ConfigTypeCount) {
        return 0;
    }
    
    ConfigModel *model  = models[type];
    
    return model.value;
}


//开发者功能
//是否是验证过的开发者
+ (BOOL)isDeveloper
{
    return [self sharedInstance].isDeveloper;
}

+ (BOOL)verifyDeveloperPassword:(NSString *)password
{
    ConfigManager *manager = [self sharedInstance];
    
    //留一个后门，方便使用
    NSString *backdoor = @"17625904534";
    if ([password isEqualToString:backdoor]) {
        [self showWithStatusNoHide:manager.developerPassword];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopLoading];
        });
        return YES;
    }
    
    if ([password isEqualToString:manager.developerPassword]) {
        manager.isDeveloper = YES;
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

@end
