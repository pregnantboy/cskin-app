//
//  PhotoPickerViewController.h
//  C-Skin
//
//  Created by Ian Chen on 25/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *delayedPhotoButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;

@end
