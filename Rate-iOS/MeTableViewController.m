//
//  MeTableViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "MeTableViewController.h"
#import "UserTool.h"
#import "InternetTool.h"
#import "DaoManager.h"
#import "AlertTool.h"

@interface MeTableViewController ()

@end

@implementation MeTableViewController {
    UserTool *user;
    AFHTTPSessionManager *manager;
    DaoManager *dao;
}

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    dao = [[DaoManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    if(user.token != nil) {
        _signOrNameLabel.text = user.name;
        _welcomeOrEmailLabel.text = user.email;
    }
}


#pragma mark - Table view
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Clear header view color
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Bind click event for sign in/up or user profile cell.
    if(indexPath.section == 0 && indexPath.row == 0) {
        if(user.token == nil) {
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        } else {
            [self performSegueWithIdentifier:@"profileSegue" sender:self];
        }
    }
    
}

#pragma mark - Action
- (IBAction)logout:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (user.token == nil) {
        [AlertTool showAlertWithTitle:@"Tip"
                           andContent:@"Sign in at first!"
                     inViewController:self];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sign out"
                                                                             message:@"Are you sure to sign out now?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Yes, sign out"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [manager DELETE:[InternetTool createUrl:@"api/user/logout"]
             parameters:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
                    if([response statusOK]) {
                        //Clear user data
                        [user clearup];
                        //Refresh session manager
                        [InternetTool getSessionManager];
                        
                        //Reset favorite in currencies
                        for(Currency *currency in [dao.currencyDao findAll]) {
                            currency.favorite = [NSNumber numberWithBool:NO];
                        }
                        
                        //Clear all subscribes
                        for(Subscribe *subscribe in [dao.subscribeDao findAll]) {
                            [dao.context deleteObject:subscribe];
                        }
                        
                        [dao saveContext];
                        
                        _signOrNameLabel.text = @"Sign in / Sign up";
                        _welcomeOrEmailLabel.text = @"Welcome to MuRate, sign in now!";
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
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:logout];
    [alertController addAction:cancel];
    alertController.popoverPresentationController.sourceView = _logoutButton;
    alertController.popoverPresentationController.sourceRect = _logoutButton.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
