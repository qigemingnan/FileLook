//
//  ViewController.m
//  filesLook
//
//  Created by Bob on 2019/3/10.
//  Copyright © 2019年 hhh. All rights reserved.
//

#import "ViewController.h"
#import "FileViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self performSelector:@selector(showFileVC) withObject:nil afterDelay:3];

}

- (void)showFileVC {
    
    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:[FileViewController new]];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
    
}
@end
