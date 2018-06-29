//
//  NewsTableViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 25/11/2016.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "NewsTableViewController.h"
#import "InternetTool.h"
#import <MJRefresh/MJRefresh.h>

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController {
    AFHTTPSessionManager *manager;
    NSArray *contents;
    NSInteger selectedIndex;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getNewsSessionManager];
    
    //Bind MJRefresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNews];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([segue.identifier isEqualToString:@"newsSegue"]) {
        [segue.destinationViewController setValue:[contents objectAtIndex:selectedIndex]
                                           forKey:@"content"];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsIdentifier"
                                                            forIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *sourceLabel = (UILabel *)[cell viewWithTag:3];
    NSObject *content = [contents objectAtIndex:indexPath.row];
    titleLabel.text = [content valueForKey:@"title"];
    timeLabel.text = [content valueForKey:@"pubDate"];
    sourceLabel.text = [content valueForKey:@"source"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"newsSegue" sender:self];
}

#pragma mark - Service 
- (void)loadNews {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [manager GET:BaiduNewsApi
      parameters:@{
                   @"title": @"货币",
                   @"channelId": @"5572a109b3cdc86cf39001e0",
                   @"needHtml": @1
                   }
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSObject *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];
             NSObject *pagebean = [[data valueForKey:@"showapi_res_body"] valueForKey:@"pagebean"];
             contents = [pagebean valueForKey:@"contentlist"];
             [self.tableView reloadData];
             [self.tableView.mj_header endRefreshing];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSObject *data = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];
             if (DEBUG) {
                 NSLog(@"Error with data: %@", data);
             }
         }];
}

@end
