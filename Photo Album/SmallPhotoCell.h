//
//  SmallPhotoCell.h
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/10.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallPhotoCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UIImageView *markImgView;

@property (assign, nonatomic) BOOL isDeleteMode;

@property (assign, nonatomic) BOOL isSelected;

@end
