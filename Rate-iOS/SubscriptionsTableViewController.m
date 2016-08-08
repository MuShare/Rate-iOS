//
//  SubscribeTableViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "SubscriptionsTableViewController.h"
#import "InternetTool.h"
#import "UserTool.h"
#import "DaoManager.h"
#import <SVGKit/SVGKit.h>

@interface SubscriptionsTableViewController ()

@end

@implementation SubscriptionsTableViewController {
    AFHTTPSessionManager *manager;
    UserTool *user;
    DaoManager *dao;
    NSArray *subscribes;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    dao = [[DaoManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSMutableArray *sids = [[NSMutableArray alloc] init];
    for(Subscribe *subscribe in [dao.subscribeDao findAll]) {
        [sids addObject:subscribe.sid];
    }
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager PUT:[InternetTool createUrl:@"api/user/subscribes"]
      parameters:@{
                   @"rev": [NSNumber numberWithInteger:user.subscribeRev],
                   @"sids": sids
                   }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
             if([response statusOK]) {
                 
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if(DEBUG) {
                 NSLog(@"Server error: %@", error.localizedDescription);
             }
             InternetResponse *response = [[InternetResponse alloc] initWithError:error];
             switch ([response errorCode]) {
                     
                 default:
                     if (DEBUG) {
                         NSLog(@"Error code is %d", [response errorCode]);
                     }
                     break;
             }
         }];
}

#pragma mark - UITableViewDataSource
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
    if (user.token == nil) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITableViewCell *cell;
    if (user.token == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"subscriptionUnloginIdentifer"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"subscribeIdentifer"];
    }
    SVGKFastImageView *fromImageView = (SVGKFastImageView *)[cell viewWithTag:1];
    SVGKFastImageView *toImageView = (SVGKFastImageView *)[cell viewWithTag:2];
    fromImageView.image = [SVGKImage imageNamed:@"cn.svg"];
    toImageView.image = [SVGKImage imageNamed:@"us.svg"];
    return cell;
}

#pragma mark - Action
- (IBAction)addSubscribe:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if(user.token == nil) {
        //If user is unlogin, push to LoginViewController
        [self performSegueWithIdentifier:@"addSubscribeUnloginSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"addSubscribeSegue" sender:self];
    }
}
@end
