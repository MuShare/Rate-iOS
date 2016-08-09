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
    user = [[UserTool alloc] init];
    dao = [[DaoManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    manager = [InternetTool getSessionManager];
    if(user.token != nil) {
        _nameLabel.text = user.name;
        _welcomeLabel.text = user.email;
        _nameLabel.hidden = NO;
        _welcomeLabel.hidden = NO;
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
                        
                        //Reset favorite in currencies
                        for(Currency *currency in [dao.currencyDao findAll]) {
                            currency.favorite = [NSNumber numberWithBool:NO];
                        }
                        
                        //Clear all subscribes
                        for(Subscribe *subscribe in [dao.subscribeDao findAll]) {
                            [dao.context deleteObject:subscribe];
                        }
                        
                        [dao saveContext];
                        
                        _nameLabel.text = @"";
                        _emailLabel.text = @"";
                        _nameLabel.hidden = YES;
                        _emailLabel.hidden = YES;
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
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
