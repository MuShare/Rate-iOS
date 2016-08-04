//
//  MenuRootViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/4/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "MenuRootViewController.h"

@interface MenuRootViewController ()

@end

@implementation MenuRootViewController

#pragma mark - RESideMenuDelegate
-(void)awakeFromNib {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTabBarController"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    
    self.backgroundImage = [UIImage imageNamed:@"lauch-bg.jpg"];
    self.delegate = self;
}

-(void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}


@end
