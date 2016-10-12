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

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface PhotoListViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photoArr;
@property (strong, nonatomic) NSMutableArray *addArr;
@property (strong, nonatomic) NSMutableArray *albumArr;
@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _albumArr = [NSMutableArray array];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    NSString *dirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"photos"];
    
    NSFileManager *fmr = [NSFileManager defaultManager];
    NSArray *fileList = [fmr contentsOfDirectoryAtPath:dirPath error:nil];
    _photoArr = [fileList mutableCopy];
    
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
        
//        PHAsset *asset = [[PHAsset alloc] init];
        
        ipc.albumArr = _albumArr;
        [self presentViewController:ipc animated:YES completion:nil];
    }

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (!_addArr) {
        _addArr = [NSMutableArray array];
    }
    
    [_addArr addObject:info];
    NSLog(@"%@", info);
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

//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

#pragma mark - UICollectionView delegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
