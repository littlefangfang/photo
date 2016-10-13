//
//  AppDelegate.m
//  Photo Album
//
//  Created by xinyue-0 on 2016/10/10.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
    BOOL firstEnter;
    UIView *v;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    firstEnter = true;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (firstEnter) {
        firstEnter = false;
    }else{
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"alwaysNeedPassword"] boolValue]) {
            return;
        }
        
        if ([[self topViewController] isKindOfClass:[ViewController class]]) {
            return;
        }
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        [keyWindow setWindowLevel:UIWindowLevelNormal];
        if (!v) {
            v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            v.backgroundColor = [UIColor grayColor];
            [keyWindow addSubview:v];
            
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            tf.backgroundColor = [UIColor whiteColor];
            [tf setKeyboardType:UIKeyboardTypeNumberPad];
            [tf becomeFirstResponder];
            [tf addTarget:self action:@selector(textFChanged:) forControlEvents:UIControlEventEditingChanged];
            [tf setSecureTextEntry:YES];
            [v addSubview:tf];
            tf.center = v.center;
        }else{
            v.hidden = NO;
            [(UITextField *)v.subviews[0] becomeFirstResponder];
        }
    }

}

- (void)textFChanged:(UITextField *)sender {
    if (sender.text == [[NSUserDefaults standardUserDefaults] objectForKey:@"passwords"]) {
        v.hidden = YES;
        sender.text = nil;
        [sender endEditing:YES];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


@end
