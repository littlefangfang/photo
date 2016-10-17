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
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property (strong, nonatomic) NSMutableArray *photoArr;
@property (strong, nonatomic) NSMutableArray *albumArr;


@end

@implementation PhotoListViewController{
    NSString *dirPath;
    BOOL canDelete;
//    NSMutableArray *willDeletePhotoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES animated:YES];
    _toolBar.hidden = YES;
    canDelete = NO;
    
    _albumArr = [NSMutableArray array];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.allowsMultipleSelection = YES;
    
    [self getLocalPhoto];
}

- (void)getLocalPhoto {
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
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:photoPath forKey:@"path"];
        [dic setObject:img forKey:@"image"];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"willremove"];
        [_photoArr addObject:dic];
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

- (IBAction)tapDelete:(UIBarButtonItem *)sender {
    if (!canDelete) {
        canDelete = YES;
        _rightItem.title = @"取消";
        
    }else{
        canDelete = NO;
        _rightItem.title = @"删除";
        
        for (NSMutableDictionary *dic in _photoArr) {
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"willremove"];
        }
        
        for (int i = 0; i < _photoArr.count; i++) {
            SmallPhotoCell *cell = (id)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell setSelected:NO];
            cell.isDeleteMode = NO;
        }
    }
    _toolBar.hidden = !canDelete;
}

- (IBAction)confirmDelete:(UIBarButtonItem *)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    for (int i = 0; i < _photoArr.count; i++) {
        if ([[[_photoArr objectAtIndex:i] objectForKey:@"willremove"] boolValue] == YES) {
            [fileManager removeItemAtPath:[[_photoArr objectAtIndex:i] objectForKey:@"path"] error:&error];
            if (error) {
                NSLog(@"remove error:---%@",error);
            }
        }
    }
    [_photoArr removeAllObjects];
    [self getLocalPhoto];
    [_collectionView reloadData];
    
    canDelete = NO;
    _rightItem.title = @"删除";
    _toolBar.hidden = YES;
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
    cell.imgView.image = [[_photoArr objectAtIndex:indexPath.row] objectForKey:@"image"];
    [cell setSelected:[[[_photoArr objectAtIndex:indexPath.row] objectForKey:@"willremove"] boolValue]];
    return cell;
}

#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (canDelete) {
        SmallPhotoCell *cell = (SmallPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.isDeleteMode = YES;
        [cell setSelected:YES];
        
        [[_photoArr objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:YES] forKey:@"willremove"];
        
    }else{
        SmallPhotoCell *cell = (SmallPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.isDeleteMode = NO;
        [self performSegueWithIdentifier:@"show_detail" sender:[NSNumber numberWithInt:(int)indexPath.row]];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SmallPhotoCell *cell = (SmallPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    [[_photoArr objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:NO] forKey:@"willremove"];
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
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:fPath forKey:@"path"];
        [dic setObject:image forKey:@"image"];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"wollremove"];
        
        [_photoArr addObject:dic];
        
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
    vc.offset = CGPointMake([(NSNumber *)sender intValue] * [UIScreen mainScreen].bounds.size.width, 0);
}


@end
