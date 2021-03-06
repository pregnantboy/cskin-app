//
//  PhotoCollectionViewCell.h
//  C-Skin
//
//  Created by Ian Chen on 24/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (void)setImage:(UIImage *)image;
- (void)setTag:(NSInteger)tag;
- (NSInteger)tag;

@end