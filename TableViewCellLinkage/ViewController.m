//
//  ViewController.m
//  TableViewCellLinkage
//
//  Created by chengjie on 2018/4/14.
//  Copyright © 2018年 chengjie. All rights reserved.
//

#import "ViewController.h"

#define leftTableWidth  [UIScreen mainScreen].bounds.size.width * 0.3
#define rightTableWidth [UIScreen mainScreen].bounds.size.width * 0.7
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

#define leftCellIdentifier  @"leftCellIdentifier"
#define rightCellIdentifier @"rightCellIdentifier"


@interface ViewController ()<UITableViewDataSource,UITableViewDataSource>

@property (weak, nonatomic)  UITableView *leftTableView;
@property (weak, nonatomic)  UITableView *rightTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) return 40;
    return 8;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) return 1;
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell;
    
    if (tableView == self.leftTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组-第%ld行",indexPath.section,indexPath.row];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.rightTableView) return [NSString stringWithFormat:@"第%ld组",section];
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 如果是 左侧的 tableView 直接return
    if (scrollView == self.leftTableView) return;
    
    // 取出显示在 视图 且最靠上 的 cell 的 indexPath
    NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
    
    // 左侧 talbelView 移动的 indexPath
    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
    
    // 移动 左侧 tableView 到 指定 indexPath 居中显示
    [self.leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        
        //将右侧tableView移动到指定位置
        [self.rightTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        //取消选中效果
        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath animated:YES];
    }
}

-(UITableView *)leftTableView{
    if (!_leftTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, leftTableWidth, ScreenHeight)];
        [self.view addSubview:tableView];
        
        _leftTableView = tableView;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:leftCellIdentifier];
        
        tableView.backgroundColor = [UIColor cyanColor];
        tableView.tableFooterView = [[UIView alloc] init];
    }
    return _leftTableView;
}

-(UITableView *)rightTableView{
    if (!_rightTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(leftTableWidth, 0, rightTableWidth, ScreenHeight)];
        [self.view addSubview:tableView];
        
        _rightTableView = tableView;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:rightCellIdentifier];
        
        tableView.backgroundColor = [UIColor yellowColor];
        tableView.tableFooterView = [[UIView alloc] init];
    }
    return _rightTableView;
}


@end
