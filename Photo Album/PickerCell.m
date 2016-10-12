//
//  PickerCell.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/11.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "PickerCell.h"

@implementation PickerCell{
    UIImageView *cover;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        cover = [[UIImageView alloc] initWithFrame:self.bounds];
        cover.image = [UIImage imageNamed:@"对勾.png"];
        cover.hidden = !_isSelected;
        [self addSubview:cover];
    }
    return self;
}


- (void)selectedImage:(BOOL)selected {
    _isSelected = selected;
    [self setSelected:selected];
    cover.hidden = !selected;
}

- (void)setImageViewWith:(UIImage *)img {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self insertSubview:_imgView atIndex:0];
        _imgView.image = img;
    }else{
        _imgView.image = img;
    }
}

@end
