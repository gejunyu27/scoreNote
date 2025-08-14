//
//  SideBar.m
//  scoreNote
//
//  Created by gejunyu on 2022/1/28.
//

#import "SideBar.h"

@interface SideBar ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SideBar

- (void)setNum:(NSInteger)num
{
    _num = num;
    [self.tableView reloadData];
    self.height = LINE_HEIGHT*(num+1);
    self.tableView.height = self.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _num+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LINE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sideId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sideId"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        label.tag = 10;
        label.font = SCFONT_SIZED(12);
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = [cell.contentView viewWithTag:10];
    label.height = LINE_HEIGHT;
    label.text = indexPath.row == 0 ? nil : [NSString stringWithFormat:@"%li",indexPath.row];
    return cell;
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = NO;
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.right.mas_equalTo(0);
//        }];
    }
    return _tableView;
}

@end
