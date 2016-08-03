//
//  FeedbackViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;

- (IBAction)submitFeedback:(id)sender;

@end
