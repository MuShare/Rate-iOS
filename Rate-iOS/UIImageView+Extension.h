//
//  UIImageView+Extension.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 12/01/2017.
//  Copyright © 2017 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

@property (nonatomic) BOOL shadowContainer;

- (void)addCornerRadius:(CGFloat)raduis;

- (void)addShadowWithColor:(UIColor *)color
              shadowOffset:(CGFloat)offset
             shadowOpacity:(float)opacity;

@end
