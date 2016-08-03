//
//  FeedbackViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "FeedbackViewController.h"
#import "InternetTool.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController {
    AFHTTPSessionManager *manager;
}

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
}


- (IBAction)submitFeedback:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if([_contactTextField.text isEqualToString:@""] || [_contentTextView.text isEqualToString:@""]) {
        
        return;
    }
    
}
@end
