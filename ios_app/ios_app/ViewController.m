//
//  ViewController.m
//  ios_app
//
//  Created by fly on 2020/3/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#import "FirstNativeViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (IBAction)didPressedBtnOpen:(id)sender {
    FirstNativeViewController *firstNativeVC = [[FirstNativeViewController alloc]initWithNibName:@"FirstNativeViewController" bundle:nil];
    firstNativeVC.showMessage = @"嗨，本文案来自App第一个页面，将在第一个原生页面看到我";
    __weak __typeof(self) weakSelf = self;
    //第二个原生页面的block回调
    firstNativeVC.ReturnStrBlock = ^(NSString *message){
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //从第二个原生页面回来后通知Flutter页面更新文案
        strongSelf.lblTitle.text = message;
    };
    firstNativeVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:firstNativeVC animated:YES completion:nil];
}
@end
