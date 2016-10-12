//
//  BigPhotoCell.h
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/12.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigPhotoCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

- (void)setZoomScale;
@end
