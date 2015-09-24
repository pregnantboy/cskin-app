//
//  ViewController.h
//  C-Skin
//
//  Created by Ian Chen on 21/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h" 

@interface AddViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dateOfPicture;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end

