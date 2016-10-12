//
//  LoadingViewController.h
//  Rate-iOS
//
//  Created by lidaye on 8/5/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *useWithoutInternetButton;

- (IBAction)useWithoutInternet:(id)sender;

@end
