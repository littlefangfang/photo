//
//  BigPhotoCell.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/12.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "BigPhotoCell.h"

@interface BigPhotoCell () <UIScrollViewDelegate>


@end

@implementation BigPhotoCell

- (void)viewWillLayoutSubviews
{
    [self setZoomScale];
}

#pragma mark - Helper

- (void)setZoomScale
{
    _scrollView.delegate = self;

    _scrollView.minimumZoomScale = 1.0f;
    _scrollView.maximumZoomScale = 3.0f;
    _scrollView.zoomScale = 1.0f;
}


#pragma mark - UIScrollViewdelegate methods


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize imageViewSize = _imgView.frame.size;
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGFloat vertical = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0;
    CGFloat horizon = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0;
    _scrollView.contentInset = UIEdgeInsetsMake(vertical, horizon, vertical, horizon);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGSize imageViewSize = _imgView.frame.size;
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGFloat vertical = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0;
    CGFloat horizon = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0;
    _scrollView.contentInset = UIEdgeInsetsMake(vertical, horizon, vertical, horizon);
}


@end
