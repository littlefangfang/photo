//
//  ViewController.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/10.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController{
    NSString *_passwords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _passwords = [userDefaults objectForKey:@"passwords"];
    
    if (!_passwords) {
        [self performSegueWithIdentifier:@"enter" sender:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    if (_passwords) {
        if ([sender.text isEqualToString:_passwords]) {
            [self performSegueWithIdentifier:@"enter" sender:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
