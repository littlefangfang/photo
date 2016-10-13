//
//  SettingViewController.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/12.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (strong, nonatomic) IBOutlet UITextField *originTF;

@property (strong, nonatomic) IBOutlet UITextField *theNewTF;

@property (strong, nonatomic) IBOutlet UITextField *repeatTF;

@property (strong, nonatomic) IBOutlet UILabel *originPWLabel;

@property (strong, nonatomic) IBOutlet UISwitch *swich;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *originPW = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwords"];
    [_swich setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"alwaysNeedPassword"] boolValue]];
    
    if (originPW == nil) {
        _originTF.hidden = YES;
        _originPWLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapConfirm:(id)sender {
    NSString *originPW = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwords"];
    
    if (originPW != nil && ![originPW isEqualToString:_originTF.text]) {
        UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"原密码错误" message:@"大笨猪把密码输错了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好吧" style:UIAlertActionStyleCancel handler:nil];
        [altC addAction:action];
        [self presentViewController:altC animated:YES completion:nil];
        return;
    }
    
    if(![_theNewTF.text isEqualToString:_repeatTF.text]) {
        UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"两次新密码不一致" message:@"大笨猪两次新密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好吧" style:UIAlertActionStyleCancel handler:nil];
        [altC addAction:action];
        [self presentViewController:altC animated:YES completion:nil];
        return;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:_theNewTF.text forKey:@"passwords"];
        UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"修改成功" message:@"你真厉害" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"那当然了!" style:UIAlertActionStyleCancel handler:nil];
        [altC addAction:action];
        [self presentViewController:altC animated:YES completion:nil];
        return;
    }
    
}
- (IBAction)tapAlwaysNeedPassword:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"alwaysNeedPassword"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_originTF endEditing:YES];
    [_theNewTF endEditing:YES];
    [_repeatTF endEditing:YES];
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
