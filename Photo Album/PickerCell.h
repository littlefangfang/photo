//
//  PickerCell.h
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/11.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property (assign, nonatomic) BOOL isSelected;

- (void)selectedImage:(BOOL)selected;
- (void)setImageViewWith:(UIImage *)img;

@end
