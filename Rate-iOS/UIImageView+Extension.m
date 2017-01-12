//
//  UIImageView+Extension.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 12/01/2017.
//  Copyright © 2017 MuShare. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)addShadow {
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 1.0;
    self.clipsToBounds = NO;
}

- (void)addCornerRadius {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end
