//
//  PhotoPickerViewController.h
//  C-Skin
//
//  Created by Ian Chen on 25/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "AddViewController.h"

@interface PhotoPickerManager : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (id)initWithViewController:(UIViewController *)vc;
- (void)showImagePickerForCamera;
- (void)showImagePickerForPhotoPicker;

@end
