//
//  PhotoDetailViewController.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/12.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "BigPhotoCell.h"

@interface PhotoDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@end

@implementation PhotoDetailViewController{
    BOOL shoudNotMove;
    int idx;
    
    CGPoint contentOffsetAfterRotation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.delegate = self;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    idx = _offset.x / [UIScreen mainScreen].bounds.size.width;
    
    self.navigationController.hidesBarsOnTap = YES;
    
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!shoudNotMove) {
        [_collectionView setContentOffset:_offset animated:NO];
        shoudNotMove = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.hidesBarsOnTap = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!_photoArr) {
        return 0;
    }
    return _photoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BigPhotoCell *cell = (BigPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"big_cell" forIndexPath:indexPath];
    cell.imgView.image = [[_photoArr objectAtIndex:indexPath.row] objectForKey:@"image"];
    [cell setZoomScale];
    return cell;
}

#pragma mark - UICollectionView flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *idxArr = [_collectionView indexPathsForVisibleItems];
        NSIndexPath *idxP = [idxArr firstObject];
        idx = (int)idxP.row;
    });
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    BigPhotoCell *cell = (id)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    
    // 添加一个临时的UIImageView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[cell imgView] image]];
    [imageView setFrame:[self.view bounds]];
    [imageView setTag:999];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [imageView setContentMode:[[cell imgView] contentMode]];
    [imageView setAutoresizingMask:0xff];
    [self.view insertSubview:imageView aboveSubview:self.collectionView];
    
    // set offset.
    contentOffsetAfterRotation = CGPointMake(idx * [self.view bounds].size.height, 0);
    [[self.collectionView collectionViewLayout] invalidateLayout];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        [self.collectionView performBatchUpdates:nil completion:nil];
        
        [self.collectionView setContentOffset:contentOffsetAfterRotation];
        
        // 移除临时创建的imageView
        [[self.view viewWithTag:999] removeFromSuperview];
    }];
}

#pragma mark - UINavigationController delegate
// 设置允许的设备方向
- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskAll;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
