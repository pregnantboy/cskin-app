//
//  PhotoCollectionViewCell.m
//  C-Skin
//
//  Created by Ian Chen on 24/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell() {
    NSInteger _tag;
}

@end

@implementation PhotoCollectionViewCell

- (void)setImage:(UIImage *)image {
    [self.cameraButton setImage:image forState:UIControlStateNormal];
}

- (void)setTag:(NSInteger)tag {
    _tag = tag;
}

- (NSInteger)tag {
    return _tag;
}

@end
