//
//  ByTimeViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/14.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ByTimeViewController.h"
#import "VideoFileConfig.h"
#import "ItemViewController.h"
#import "ItemTableviewCell.h"

@interface ByTimeViewController () <UITableViewDelegate, UITableViewDataSource, VideoFileConfigDelegate>
{
    VideoFileConfig *config;
    UITableView *tableV;
    NSMutableArray *titleArray;
}
@end

@implementation ByTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    [self getVideoFileConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 按时间查询设备录像信息
- (void)getVideoFileConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[VideoFileConfig alloc] init];
        config.delegate = self;
    }
    //调用按时间查询录像的接口，查询今天的设备录像，可以自己设置日期，返回的是有录像的时间段对象数组
    [config getDeviceVideoByTime:[NSDate date]];
}
#pragma mark 获取摄像机参数代理回调
- (void)getVideoResult:(NSInteger)result {
    if (result >= 0) {
        [SVProgressHUD dismiss];
        titleArray =[config getVideoTimeArray];
        //成功，刷新界面数据
        [self.tableV reloadData];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    TimeInfo *info = [titleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d-%d",info.start_Time,info.end_Time];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    [self.view addSubview:self.tableV];
}
- (UITableView *)tableV {
    if (!tableV) {
        tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        tableV.delegate = self;
        tableV.dataSource = self;
        [tableV registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    return tableV;
}
#pragma mark - 界面和数据初始化
- (void)initDataSource {
    titleArray = [[NSMutableArray alloc] initWithCapacity:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
