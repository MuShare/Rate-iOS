//
//  NewsViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 25/11/2016.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController

@property (nonatomic, strong) NSObject *content;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@end
