//
//  FileViewController.m
//  filesLook
//
//  Created by Bob on 2019/3/10.
//  Copyright © 2019年 hhh. All rights reserved.
//

#import "FileViewController.h"

@interface FileViewController ()

<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,copy)NSArray * arr;
@property(nonatomic, copy)NSString * parentPath;
//当前文件所在的全路径
@property(nonatomic, copy)NSString * currentFilePath;

@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.view addSubview:self.myTableView];
  
    
    if (self.arr) {
        
    }else {
        
        self.arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSHomeDirectory() error:nil];
        self.parentPath = NSHomeDirectory();
    }
    
    
}
#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.arr.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text =  self.arr[indexPath.section];
    cell.textLabel.numberOfLines = 0;
    
    
    
    NSString * patha = [self.parentPath stringByAppendingPathComponent:cell.textLabel.text];
    
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:patha isDirectory:&isDir];
    if (isDir) {
        cell.backgroundColor = [UIColor cyanColor];
        
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString * patha = [self.parentPath stringByAppendingPathComponent:cell.textLabel.text];
    
    
    if ([[NSFileManager defaultManager] contentsOfDirectoryAtPath:patha error:nil].count) {
        
        
        FileViewController * VC = [[FileViewController alloc]init];
        VC.arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:patha error:nil];
        VC.parentPath = patha;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else {
        BOOL isDir = NO;
        
        [[NSFileManager defaultManager] fileExistsAtPath:patha isDirectory:&isDir];
        
        if (isDir) {
            FileViewController * VC = [[FileViewController alloc]init];
            VC.arr = @[];
            VC.parentPath = patha;
            [self.navigationController pushViewController:VC animated:YES];
        }else {
            self.currentFilePath = patha;
            [self showActionSheet];
            
        }
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
//MARK: -   根据数组，来动态加载 actionsheet

- (void)showActionSheet {
    NSArray * arraaa = @[
                         @"文件详情",
                         @"操作一",
                         @"。。。",

                         ];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate: (id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (int i = 0; i < arraaa.count; i++) {
        
        NSString *title = [arraaa objectAtIndex:i];
        
        [actionSheet addButtonWithTitle:title];
        
    }
    
    
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString * str = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    
  if ([str isEqualToString:@"文件详情"]) {
        [self showDetailInfoAtPath:self.currentFilePath];
        
        
    }else  if ([str isEqualToString:@"取消"]) {
        //        清除当前路径信息
        self.currentFilePath = nil;
        
    }
    
    
}

- (void)showDetailInfoAtPath:(NSString *)patha {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary * infoaaa = [fileManager attributesOfItemAtPath:patha error:nil];
    
    UIAlertView * alerta = [[UIAlertView alloc]initWithTitle:@"详情" message:[NSString stringWithFormat:@"创建日期：%@ \nNSFileExtensionHidden：%@ \nNSFileGroupOwnerAccountID：%@ \nNSFileGroupOwnerAccountName：%@ \n修改日期：%@ \nNSFileOwnerAccountID：%@ \nNSFilePosixPermissions：%@ \nNSFileReferenceCount：%@ \n文件大小：%@byte \n 折合：%.2fKB\n 折合：%.4fMB\nNSFileSystemFileNumber：%@ \nNSFileSystemNumber：%@ \nSFileType：%@ ", infoaaa[@"NSFileCreationDate"], infoaaa[@"NSFileExtensionHidden"], infoaaa[@"nNSFileGroupOwnerAccountID"], infoaaa[@"NSFileGroupOwnerAccountName"], infoaaa[@"NSFileModificationDate"], infoaaa[@"NSFileOwnerAccountID"], infoaaa[@"NSFilePosixPermissions"], infoaaa[@"NSFileReferenceCount"], infoaaa[@"NSFileSize"] , [infoaaa[@"NSFileSize"] floatValue]/1024.0 , [infoaaa[@"NSFileSize"] floatValue]/(1024*1024.0), infoaaa[@"NSFileSystemFileNumber"], infoaaa[@"NSFileSystemNumber"],infoaaa[@"NSFileType"] ] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alerta show];
    
    
    
}



//MARK: - 懒加载
- (UITableView *)myTableView {
    
    if (_myTableView == nil) {
        CGFloat appw = [UIScreen mainScreen].bounds.size.width;
        CGFloat apph = [UIScreen mainScreen].bounds.size.height;
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, appw,apph-64) style:UITableViewStyleGrouped];
        
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.sectionHeaderHeight = 0;
        _myTableView.sectionFooterHeight = 20;
        
        _myTableView.backgroundColor = [UIColor lightGrayColor];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    
    return _myTableView;
    
}

@end
