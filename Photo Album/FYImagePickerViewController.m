//
//  FYImagePickerViewController.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/10.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "FYImagePickerViewController.h"
#import "PickerCell.h"



@interface FYImagePickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation FYImagePickerViewController{
    NSMutableArray *fullArr;
    NSMutableArray *selectedArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    fullArr = [NSMutableArray array];
    selectedArr = [NSMutableArray array];
    
    for (int i = 0; i < _albumArr.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"image"] = [_albumArr objectAtIndex:i];
        dic[@"index"] = [NSNumber numberWithInt:i];
        [fullArr addObject:dic];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;
    [_collectionView registerClass:[PickerCell class] forCellWithReuseIdentifier:@"picker_cell"];
    [self.view addSubview:_collectionView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, [UIScreen mainScreen].bounds.size.width, 30)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(bottomView.frame.size.width - 50, 0, 50, 30)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 50, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(tapCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:cancelBtn];
    [bottomView addSubview:btn];
    [self.view addSubview:bottomView];
    
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)confirmSelect:(id)sender {
    if ([_pickerDelegate respondsToSelector:@selector(didFinishSelected:)]) {
        [_pickerDelegate didFinishSelected:selectedArr];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapCancel:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!fullArr) {
        return 0;
    }
    return fullArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PickerCell *cell = (PickerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"picker_cell" forIndexPath:indexPath];
    [cell setImageViewWith:[[fullArr objectAtIndex:indexPath.row] objectForKey:@"image"]];
    [cell selectedImage:cell.isSelected];
    return cell;
}

#pragma mark - UICollectionView flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 100);
}

#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PickerCell *cell = (PickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selectedImage:YES];
    [selectedArr addObject:[fullArr objectAtIndex:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    PickerCell *cell = (PickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selectedImage:NO];
    for (NSMutableDictionary *item in selectedArr) {
        if ([(NSNumber *)[[fullArr objectAtIndex:indexPath.row] objectForKey:@"index"] intValue] == [(NSNumber *)[item objectForKey:@"index"] intValue]) {
            [selectedArr removeObject:item];
        }
    }
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
