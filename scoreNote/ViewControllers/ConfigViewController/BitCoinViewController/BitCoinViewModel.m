//
//  BitCoinViewModel.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2026/6/7.
//

#import "BitCoinViewModel.h"
#import "TagManager.h"
#import "RecordManager.h"

@implementation BitCoinViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    _dataList = [NSMutableArray array];
    
    NSData *data = [NSData dataWithContentsOfFile:[self filePath]];
    if (!data) {
        return;
    }
    
    NSError *error = nil;
    
    NSArray *readArr = [NSKeyedUnarchiver  unarchivedObjectOfClasses:[NSSet setWithArray:@[NSArray.class, BitCoinModel.class, NSDate.class]] fromData:data error:&error];
    
    if (!error && readArr.count > 0) {
        _dataList = readArr.mutableCopy;
    }
}

- (NSString *)filePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"BitCoinArray.archive"];
    
    return filePath;
}


- (void)archiveData
{
    NSError *error = nil;
    
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:_dataList requiringSecureCoding:NO error:&error];
    
    if (!error) {
        [archiveData writeToFile:[self filePath] atomically:YES];
    }
}

- (NSArray<FinanceModel *> *)financeList
{
    //充值金额
    CGFloat rechargeMoney = 0;
    //提现金额
    CGFloat withdrawMoney = 0;
    
    for (BitCoinModel *model in self.dataList) {
        CGFloat money = model.money.floatValue;
        
        if (model.isRecharge) { //充值
            rechargeMoney += money;
        }else {
            withdrawMoney += money;
        }
    }
    
    //现金流
    CGFloat flowMoney = withdrawMoney - rechargeMoney;
    
    FinanceModel *flowModel     = [[FinanceModel alloc] initWithTitle:@"现金流" content:[SCUtilities removeFloatSuffix:flowMoney]];
    FinanceModel *rechargeModel = [[FinanceModel alloc] initWithTitle:@"累计充值" content:[SCUtilities removeFloatSuffix:rechargeMoney]];
    FinanceModel *withdrawModel = [[FinanceModel alloc] initWithTitle:@"累计提现" content:[SCUtilities removeFloatSuffix:withdrawMoney]];
    
    return @[flowModel, rechargeModel, withdrawModel];
}

- (BOOL)migrationData
{
    //获取比特币标签
    TagModel *bitcoinTag = [TagManager getTagWithName:NAME_BIT_COIN];
    
    if (!bitcoinTag) {
        return NO;
    }
    
    RecordModel *record = [RecordModel new];
    record.tagId = bitcoinTag.tagId;
    record.isOver = YES;
    
    //倒序插入列
    [_dataList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BitCoinModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        LineModel *line = [LineModel new];
        if (model.isRecharge) {
            line.outMoney = model.money.floatValue;
            line.getMoney = 0;

        }else {
            line.outMoney = 0;
            line.getMoney = model.money.floatValue;
        }
        line.isOver = YES;
        line.beginTime = model.date;
        line.endTime   = model.date;
        [record addLine:line];
        
    }];
    
    BOOL success = [DataManager migrationData:record];
    
    if (success) {
        [_dataList removeAllObjects];
    }
    
    return success;
}

@end
