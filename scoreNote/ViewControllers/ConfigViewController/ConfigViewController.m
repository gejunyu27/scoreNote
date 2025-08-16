//
//  ConfigViewController.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "ConfigViewController.h"
#import "ConfigCell.h"
#import "BitCoinViewController.h"
#import <Social/Social.h>
#import "SqlEditViewController.h"
#import "ColumnAddViewController.h"

#define kConfigCell @"ConfigCell"

@interface ConfigViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *targetButton;
@property (weak, nonatomic) IBOutlet UIButton *firstPointButton;
@property (weak, nonatomic) IBOutlet UIButton *secondPointButton;

@property (weak, nonatomic) IBOutlet UILabel *firstPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPayLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *backdoorLabel;


@property (nonatomic, assign) BOOL hasUpdate;

@property (nonatomic, copy) NSString *developerPassword;
@property (nonatomic, assign) BOOL isDeveloper;

@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [_tableView registerNib:[UINib nibWithNibName:kConfigCell bundle:nil] forCellReuseIdentifier:kConfigCell];
    
    //后门程序
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backdoorAction)];
    ges.numberOfTapsRequired = 15;
    [_backdoorLabel addGestureRecognizer:ges];
    _backdoorLabel.userInteractionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_hasUpdate) {
        _hasUpdate = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CONFIG_UPDATE object:nil];
    }
}

- (void)backdoorAction
{
    //后门程序
    [self showWithStatus:self.developerPassword];
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

#pragma mark -action
- (IBAction)calculateMoneyAction:(UIButton *)sender {
    
    @weakify(self)
    [NumberInputView showWithText:sender.titleLabel.text title:@"双平计算" clickView:sender type:InputTypeNoSymbol block:^(NSString * _Nonnull outputText) {
        @strongify(self)
        [sender setTitle:outputText forState:UIControlStateNormal];
        sender.titleLabel.text = outputText; //不加会有bug,原因未知
        
        //计算
        CGFloat target = self.targetButton.titleLabel.text.floatValue;
        CGFloat point1 = self.firstPointButton.titleLabel.text.floatValue;
        CGFloat point2 = self.secondPointButton.titleLabel.text.floatValue;
        
        if (target > 0 && point1 > 0 && point2 > 0) {
            CGFloat pay1 = point2*target/(point1*point2-point1-point2);
            CGFloat pay2 = point1*target/(point1*point2-point1-point2);
            self.firstPayLabel.text = [NSString stringWithFormat:@"结果：%@",[SCUtilities removeFloatSuffix:pay1]];
            self.secondPayLabel.text = [NSString stringWithFormat:@"结果：%@",[SCUtilities removeFloatSuffix:pay2]];
            
        }else {
            self.firstPayLabel.text = @"结果：";
            self.secondPayLabel.text = @"结果：";
        }
    }];
}

- (IBAction)bitCoinAction:(UIButton *)sender {
    [self.navigationController pushViewController:[BitCoinViewController new] animated:YES];
}

- (IBAction)developerAction:(UIButton *)sender {
    
    if (_isDeveloper) { //是开发者直接进入
        [self pushDeveloper];
        return;
    }
    //不是开发者要先输密码
    [self developerPassword];
    [NumberInputView showWithText:nil title:@"开发者密码" clickView:nil type:InputTypeNoDot block:^(NSString * _Nonnull outputText) {
        if (outputText.length > 0) {
            if ([outputText isEqualToString:self.developerPassword]) {
                self.isDeveloper = YES; //下次再进不用输密码
                [self pushDeveloper];
                
            }else {
                [self showWithStatus:@"密码错误"];
            }
        }

    }];
    
}

- (void)pushDeveloper
{

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"修改数据库数据" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[SqlEditViewController new] animated:YES];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"增加数据库字段" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[ColumnAddViewController new] animated:YES];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}


- (IBAction)deleteDataAction:(id)sender {
    NSString *filePath = [DataManager sqliteFilePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self showWithStatus:@"暂无数据"];
        
        return;
    }
    
    [SCUtilities alertWithTitle:@"警告" message:@"数据库删除后将无法恢复" textFieldBlock:nil sureBlock:^(NSString * _Nullable text) {
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (result && !error) {
            [self showWithStatus:@"删除成功"];
            [DataManager clear];
        }else {
            [self showWithStatus:@"删除失败"];
        }
    }];
    
}

- (IBAction)shareDataAction:(id)sender {
    
    NSString *filePath = [DataManager sqliteFilePath];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSArray*activityItems =@[fileData, fileURL];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
    activityVC.completionWithItemsHandler = ^(UIActivityType activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
        
    };
    
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfigCell];
    cell.type = indexPath.row;
    
    @weakify(self)
    cell.updateBlock = ^{
        @strongify(self)
        self.hasUpdate = YES;
    };
    
    return cell;
}


@end
