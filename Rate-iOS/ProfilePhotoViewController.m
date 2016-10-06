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

@interface ProfilePhotoViewController ()

@end

@implementation ProfilePhotoViewController {
    UIImagePickerController *imagePickerController;
    AFHTTPSessionManager *manager;
    DaoManager *dao;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
    dao = [[DaoManager alloc] init];
    //Init ImagePickerController
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
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
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                  URLString:[InternetTool createUrl:@"api/user/upload_image"]
                                                                                                 parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                                     [formData appendPartWithFileData:UIImageJPEGRepresentation(_profilePhotoImageView.image, 1.0)
                                                                                                                                 name:@"file" fileName:@"avatar.jpg"
                                                                                                                             mimeType:@"image/jpeg"];
            
                                                                                                 }
                                                                                                      error:nil];
        
        NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request
                                                                     progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             NSLog(@"%f", uploadProgress.fractionCompleted);
                                                                         });
                                                                     }
                                                            completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                             
                                                                InternetResponse *res = [[InternetResponse alloc] initWithError:error];
                                                                switch ([res errorCode]) {
                                                                        
                                                                    default:
                                                                        break;
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit Profile Photo"
                                                                             message:@"Choose a photo from library or take a photo."
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePickerController.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
            imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
            imagePickerController.allowsEditing=YES;
        }else{
            if (DEBUG) {
                NSLog(@"iOS Simulator cannot open camera.");
            }
            [AlertTool showAlertWithTitle:@"Warning"
                               andContent:@"iOS Simulator cannot open camera."
                         inViewController:self];
        }
        [self presentViewController:imagePickerController animated: YES completion:nil];
    }];
    
    UIAlertAction *choose = [UIAlertAction actionWithTitle:@"Choose from Photos"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated: YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:takePhoto];
    [alertController addAction:choose];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
