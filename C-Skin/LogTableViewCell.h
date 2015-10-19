//
//  LogTableViewCell.h
//  C-Skin
//
//  Created by Ian Chen on 5/10/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateOfSubmission;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@end
