//
//  AlertTool.m
//  MuShare-iOS
//
//  Created by 李大爷的电脑 on 7/12/16.
//  Copyright © 2016 limeng. All rights reserved.
//

#import "AlertTool.h"

@implementation AlertTool

+ (void)showAlertWithTitle:(NSString *)title
                andContent:(NSString *)content
          inViewController:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:content
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok_name", @"OK")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

+ (void)replaceBarButtonItemWithActivityIndicator:(UIViewController *)controller {
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    controller.navigationItem.rightBarButtonItem = barButton;
    [activityIndicatorView startAnimating];
}

+ (void)showNotConnectInternet:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"tip_name", @"Tip")
                                                                             message:NSLocalizedString(@"no_internet_connection", @"The Internet connection appears to be offline.")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok_name", @"OK")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end
