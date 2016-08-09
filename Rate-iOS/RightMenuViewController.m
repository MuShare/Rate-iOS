//
//  RightMenuViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/8/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "RightMenuViewController.h"
#import "UserTool.h"

@interface RightMenuViewController ()

@end

@implementation RightMenuViewController {
    UserTool *user;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    
    user = [[UserTool alloc] init];
    
    if(user.token != nil) {
        _nameLabel.text = user.name;
        _emailLabel.text = user.email;
    }
    
    
}




@end
