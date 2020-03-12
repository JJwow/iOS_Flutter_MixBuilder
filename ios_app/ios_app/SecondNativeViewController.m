//
//  SecondNativeViewController.m
//  ios_app
//
//  Created by fly on 2020/3/11.
//  Copyright © 2020 admin. All rights reserved.
//

#import "SecondNativeViewController.h"

@interface SecondNativeViewController ()

@end

@implementation SecondNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblTitle.text = self.showMessage;
}

- (IBAction)didPressedBackFlutter:(id)sender {
    if (self.ReturnStrBlock) {
        self.ReturnStrBlock(@"嗨，本文案来自第二个原生页面，将在Flutter页面看到我");
    }
    [self dismissViewControllerAnimated: YES completion: nil];
}
@end
