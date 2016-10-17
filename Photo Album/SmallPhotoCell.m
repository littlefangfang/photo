//
//  SmallPhotoCell.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/10.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "SmallPhotoCell.h"

@implementation SmallPhotoCell

- (void)setSelected:(BOOL)selected {
    if(_isDeleteMode) {
        _isSelected = selected;
        _markImgView.hidden = !selected;
    }else{
        _isSelected = selected;
        _markImgView.hidden = YES;
    }
}

@end
