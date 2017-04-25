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
    AppDelegate *delegate;
}

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dao = [[DaoManager alloc] init];
    user = [[UserTool alloc] init];
    manager = [InternetTool getSessionManager];
    
    //Set UISwitch
    _showFavoriteSwitch.on = user.showFavorites;
    _notificationSwitch.on = user.notification;
    
}

- (void)viewWillAppear:(BOOL)animated {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    if (user.token != nil) {
        _signOrNameLabel.text = user.name;
        _welcomeOrEmailLabel.text = user.email;
        _showFavoriteSwitch.enabled = YES;
        _notificationSwitch.enabled = YES;
        
        // Set user avatar if it is not nil.
        if (user.avatar != nil) {
            _avatarImageView.image = [UIImage imageWithData:user.avatar];
        }
        
        // Refresh user avatar
        [self downloadAvatar];
    } else {
        _notificationSwitch.enabled = NO;
        _showFavoriteSwitch.enabled = NO;
    }
}


#pragma mark - Table view
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Clear header view color
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Bind click event for sign in/up or user profile cell.
    if (indexPath.section == 0 && indexPath.row == 0) {
        if(user.token == nil) {
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        } else {
            [self performSegueWithIdentifier:@"profileSegue" sender:self];
        }
    }
    // Bind Github
    if (indexPath.section == 2 && indexPath.row == 3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/MuShare/Rate-iOS"]];
    }
}

#pragma mark - Action
- (IBAction)logout:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (user.token == nil) {
        [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"Tip")
                           andContent:NSLocalizedString(@"sign_in_at_first", @"Sign in at first!")
                     inViewController:self];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"sign_out", @"Sign out")
                                                                             message:NSLocalizedString(@"sign_out_tip", @"Are you sure to sign out now?")
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:NSLocalizedString(@"sign_out_yes", @"Yes, sign out")
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [manager DELETE:[InternetTool createUrl:@"api/user/logout"]
             parameters:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
                    if([response statusOK]) {
                        //Clear user data
                        [user clearup];
                        //Clear token
                        [InternetTool clearToken];
                        
                        //Reset favorite in currencies
                        for(Currency *currency in [dao.currencyDao findAll]) {
                            currency.favorite = [NSNumber numberWithBool:NO];
                        }
                        
                        //Clear all subscribes
                        for(Subscribe *subscribe in [dao.subscribeDao findAll]) {
                            [dao.context deleteObject:subscribe];
                        }
                        
                        [dao saveContext];
                        
                        _signOrNameLabel.text = NSLocalizedString(@"sign_in_sign_up", @"Sign in / Sign up");
                        _welcomeOrEmailLabel.text = NSLocalizedString(@"welcome_message", @"Welcome to MuRate, sign in now!");
                        _notificationSwitch.enabled = NO;
                        _avatarImageView.image = [UIImage imageNamed:@"me_user"];
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if(DEBUG) {
                        NSLog(@"Server error: %@", error.localizedDescription);
                        
                    }
                    InternetResponse *response = [[InternetResponse alloc] initWithError:error];
                    switch ([response errorCode]) {
                        case ErrorCodeNotConnectedToInternet:
                            [AlertTool showNotConnectInternet:self];
                            break;
                        case ErrorCodeTokenError:
                            
                            break;
                        default:
                            break;
                    }
                }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel_name", @"Cancel")
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:logout];
    [alertController addAction:cancel];
    alertController.popoverPresentationController.sourceView = _logoutButton;
    alertController.popoverPresentationController.sourceRect = _logoutButton.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)changeShowFavorite:(UISwitch *)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    user.showFavorites = sender.on;
    delegate.refreshRates = YES;
}

- (IBAction)changeNotification:(UISwitch *)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    [manager POST:[InternetTool createUrl:@"api/user/notification"]
       parameters:@{
                    @"enable": [NSNumber numberWithBool:sender.on]
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if([response statusOK]) {
                  user.notification = sender.on;
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if(DEBUG) {
                  NSLog(@"Server error: %@", error.localizedDescription);
              }
              sender.on = !sender.on;
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {
                  case ErrorCodeNotConnectedToInternet:
                      [AlertTool showNotConnectInternet:self];
                      break;
                  default:
                      break;
              }
          }];
}

#pragma mark - Service 
- (void)downloadAvatar {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [manager GET:[InternetTool createUrl:@"api/user/avatar"]
      parameters:@{@"rev": [NSNumber numberWithInteger:user.avatarRev]}
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
            if([response statusOK]) {
                NSObject *result = [response getResponseResult];
                if ([[result valueForKey:@"isUpdated"] boolValue]) {
                    user.avatar = [[NSData alloc] initWithBase64EncodedString:[result valueForKey:@"image"]
                                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    user.avatarRev = [[result valueForKey:@"rev"] integerValue];
                    _avatarImageView.image = [UIImage imageWithData:user.avatar];
                }
            }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             InternetResponse *response = [[InternetResponse alloc] initWithError:error];
             switch ([response errorCode]) {
                 case ErrorCodeNotConnectedToInternet:
                     [AlertTool showNotConnectInternet:self];
                     break;
                 default:
                     break;
             }
         }];
}
@end
