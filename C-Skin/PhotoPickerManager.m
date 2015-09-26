//
//  PhotoPickerViewController.m
//  C-Skin
//
//  Created by Ian Chen on 25/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import "PhotoPickerManager.h"

@interface PhotoPickerManager () {
    UIViewController *_vc;
    UIImagePickerController *_imagePickerController;
    NSMutableArray *_capturedImages;
}

@end

@implementation PhotoPickerManager


- (id)initWithViewController:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        _capturedImages = [[NSMutableArray alloc] init];
        _vc = vc;
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
        [self finishAndUpdate];
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
    if (_capturedImages.count > 0)
    {
        [_capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
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


- (void)finishAndUpdate
{
    [_vc dismissViewControllerAnimated:YES completion:NULL];

    if ([_capturedImages count] == 1)
    {
            // Camera took a single picture.
            //[self.imageView setImage:[self.capturedImages objectAtIndex:0]];
    }

    // To be ready to start again, clear the captured images array.
//    [self.capturedImages removeAllObjects];
//    self.imagePickerController = nil;
    NSLog(@"done!");
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [_capturedImages addObject:image];

    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_vc dismissViewControllerAnimated:YES completion:NULL];
}

@end
