//
//  PhotoListViewController.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/10.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "PhotoListViewController.h"
#import <Photos/Photos.h>
#import "FYImagePickerViewController.h"
#import "SmallPhotoCell.h"
#import "PhotoDetailViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface PhotoListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FYImagePickerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photoArr;
@property (strong, nonatomic) NSMutableArray *addArr;
@property (strong, nonatomic) NSMutableArray *albumArr;
@end

@implementation PhotoListViewController{
    NSString *dirPath;
    int idx;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    _albumArr = [NSMutableArray array];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    dirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"photos"];
    _photoArr = [NSMutableArray array];
    
    NSFileManager *fmr = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fmr fileExistsAtPath:dirPath isDirectory:&isDir]) {
        [fmr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *fileList = [fmr contentsOfDirectoryAtPath:dirPath error:nil];
    for (int i = 0; i < fileList.count; i++) {
        NSString *photoPath = [dirPath stringByAppendingPathComponent:[fileList objectAtIndex:i]];
        UIImage *img = [UIImage imageWithContentsOfFile:photoPath];
        [_photoArr addObject:img];
    }
    
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        PHImageManager *imgMgr = [PHImageManager defaultManager];
        [imgMgr requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [_albumArr addObject:result];
        }];
    }];

}

- (IBAction)getPhotoFromAlbum:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        FYImagePickerViewController *ipc = [[FYImagePickerViewController alloc] init];
        ipc.pickerDelegate = self;
        ipc.albumArr = _albumArr;
        [self presentViewController:ipc animated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!_photoArr) {
        return 0;
    }
    return _photoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SmallPhotoCell *cell = (SmallPhotoCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:@"small_photo_cell" forIndexPath:indexPath];
    cell.imgView.image = [_photoArr objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    idx = (int)indexPath.row;
}

#pragma mark - FYPickerDelegate
- (void)didFinishSelected:(NSMutableArray *)selectedPhoto {
    for (int i = 0; i < selectedPhoto.count; i++) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
        [dfm setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *dateStr = [dfm stringFromDate:date];
        NSString *fPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",dateStr,i]];
        
        UIImage *image = [[selectedPhoto objectAtIndex:i] objectForKey:@"image"];
        [_photoArr addObject:image];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [data writeToFile:fPath atomically:YES];
    }
    [_collectionView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PhotoDetailViewController *vc = (PhotoDetailViewController *)[segue destinationViewController];
    vc.photoArr = _photoArr;
    [vc.collectionView setContentOffset:CGPointMake(idx * [UIScreen mainScreen].bounds.size.width, 0) animated:NO];
}


@end
