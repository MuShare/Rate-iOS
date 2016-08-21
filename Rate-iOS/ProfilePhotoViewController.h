//
//  ProfilePhotoViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/19/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;

- (IBAction)editProfilePhoto:(id)sender;

@end
