//
//  FYImagePickerViewController.h
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/10.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYImagePickerDelegate <NSObject>

@optional
- (void)didFinishSelected:(NSMutableArray *)selectedPhoto;

@end

@interface FYImagePickerViewController : UINavigationController

@property (strong, nonatomic) NSMutableArray *albumArr;

@property (weak, nonatomic) id<FYImagePickerDelegate> pickerDelegate;

@end
