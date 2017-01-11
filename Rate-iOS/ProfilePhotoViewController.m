//
//  ProfilePhotoViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/19/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "ProfilePhotoViewController.h"
#import "InternetTool.h"
#import "DaoManager.h"
#import "AlertTool.h"
#import "UserTool.h"

@interface ProfilePhotoViewController ()

@end

@implementation ProfilePhotoViewController {
    UIImagePickerController *imagePickerController;
    AFHTTPSessionManager *manager;
    DaoManager *dao;
    UserTool *user;
    
    UIView *maskView;
    UILabel *tipLabel;
    NSString *uploadingProgressTip;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
    dao = [[DaoManager alloc] init];
    user = [[UserTool alloc] init];
    uploadingProgressTip = NSLocalizedString(@"uploading_avatar", nil);
    
    //Init ImagePickerController
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    //Set user avatar if it is not nil.
    if (user.avatar != nil) {
        _profilePhotoImageView.image = [UIImage imageWithData:user.avatar];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class,NSStringFromSelector(_cmd));
        NSLog(@"MediaInfo: %@", info);
    }
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        _profilePhotoImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    //Hide UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //Upload image
    if(_profilePhotoImageView.image != nil) {
        //Add a mask.
        [self showTipMask];
        
        //Start uploading.
        NSData *avatar = UIImageJPEGRepresentation(_profilePhotoImageView.image, 1.0);
        NSMutableURLRequest *request =
        [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                   URLString:[InternetTool createUrl:@"api/user/upload_image"]
                                                                  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                      [formData appendPartWithFileData:avatar
                                                                                                  name:@"file" fileName:@"avatar.jpg"
                                                                                              mimeType:@"image/jpeg"];
                                                                      
                                                                  }
                                                                       error:nil];
        [request setValue:user.token forHTTPHeaderField:@"token"];
        NSURLSessionUploadTask *task =
        [manager uploadTaskWithStreamedRequest:request
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              tipLabel.text = [NSString stringWithFormat:@"%.0f%@", uploadProgress.fractionCompleted * 100, uploadingProgressTip];
                                              if (uploadProgress.fractionCompleted == 1) {
                                                  tipLabel.text = NSLocalizedString(@"uploading_processing", nil);
                                              }
                                          });
                                      }
                             completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                 
                                 if (error == nil) {
                                     InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
                                     if ([response statusOK]) {
                                         user.avatar = avatar;
                                         user.avatarRev ++;
                                         [self removeMask];
                                     }
                                 } else {
                                     InternetResponse *res = [[InternetResponse alloc] initWithError:error];
                                     switch ([res errorCode]) {
                                         case ErrorCodeNotConnectedToInternet:
                                             [AlertTool showNotConnectInternet:self];
                                             break;
                                         default:
                                             break;
                                     }
                                 }
                                 
                             }];
        [task resume];
    }
}

#pragma mark - Action
- (void)editProfilePhoto:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"photo_edit", @"Edit Profile Photo")
                                                                             message:NSLocalizedString(@"photo_tip",@"Choose a photo from library or take a photo.")
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"photo_take",@"Take Photo")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.allowsEditing = YES;
        } else {
            if (DEBUG) {
                NSLog(@"iOS Simulator cannot open camera.");
            }
            [AlertTool showAlertWithTitle:NSLocalizedString(@"warning_nane", @"Warning")
                               andContent:NSLocalizedString(@"photo_simulator_not_support",@"iOS Simulator cannot open camera.")
                         inViewController:self];
        }
        [self presentViewController:imagePickerController animated: YES completion:nil];
    }];
    
    UIAlertAction *choose = [UIAlertAction actionWithTitle:NSLocalizedString(@"photo_choose",@"Choose from Photos")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated: YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel_name", @"Cancel")
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:takePhoto];
    [alertController addAction:choose];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Service

- (void)showTipMask {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2 + 40, self.view.frame.size.width, 20)];
    tipLabel.text = [NSString stringWithFormat:@"%.2f%@", 0.0, uploadingProgressTip];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [maskView addSubview:tipLabel];
    UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingActivityIndicatorView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [loadingActivityIndicatorView startAnimating];
    [maskView addSubview:loadingActivityIndicatorView];
    [self.tabBarController.view addSubview:maskView];
}

- (void)removeMask {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [maskView removeFromSuperview];
}
@end
