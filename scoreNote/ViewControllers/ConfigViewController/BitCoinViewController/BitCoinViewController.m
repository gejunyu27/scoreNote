//
//  BitCoinViewController.m
//  scoreNote
//
//  Created by Zhuanz密码0000 on 2024/6/8.
//

#import "BitCoinViewController.h"

@interface BitCoinViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation BitCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"比特币账本";

}

- (void)reload
{
}

#pragma mark -data



@end

