//
//  PhotoPickerViewController.m
//  C-Skin
//
//  Created by Ian Chen on 25/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import "PhotoPickerManager.h"

@interface PhotoPickerManager () {
    AddViewController *_vc;
    UIImagePickerController *_imagePickerController;
}

@end

@implementation PhotoPickerManager


- (id)initWithViewController:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        _vc = (AddViewController *)vc;
    }
    return self;
}

- (void)showImagePickerForCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No camera detected on device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
       // [_vc dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)showImagePickerForPhotoPicker
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface.
         */
        imagePickerController.showsCameraControls = YES;
        
    }
    
    _imagePickerController = imagePickerController;
    [_vc presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    [_vc dismissViewControllerAnimated:YES completion:NULL];
    
    [_vc addPhotoToArray:image];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_vc dismissViewControllerAnimated:YES completion:NULL];
}

@end
