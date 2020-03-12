//
//  FirstNativeViewController.m
//  ios_app
//
//  Created by fly on 2020/3/11.
//  Copyright © 2020 admin. All rights reserved.
//

#import "FirstNativeViewController.h"
#import "SecondNativeViewController.h"
#import <Flutter/Flutter.h>
static NSString *CHANNEL_NATIVE = @"com.example.flutter/native";
static NSString *CHANNEL_FLUTTER = @"com.example.flutter/flutter";
@interface FirstNativeViewController ()
@property (nonatomic, strong) FlutterViewController *flutterViewController;
@property (nonatomic, copy) NSString *sMessageFromFlutter;
@end

@implementation FirstNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //显示初始页面传过来的内容
    self.lblTitle.text = self.showMessage;
}

- (IBAction)didOressedBtnPushFlutter:(id)sender {
    [self configFlutterWithOutFlutterEngine];
        //若使用FlutterEngine初始化Flutter页面时，使用下面👇注释内容
//        [self configFlutterWithFlutterEngine];
}

- (IBAction)didPressedBack:(id)sender {
    if (self.ReturnStrBlock) {
        self.ReturnStrBlock(@"嗨，本文案来自第一个原生页面，将在App第一个页面看到我");
    }
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)configFlutterWithOutFlutterEngine{
    __weak __typeof(self) weakSelf = self;
    //初始化FlutterViewController
    self.flutterViewController = [[FlutterViewController alloc] init];
    //为FlutterViewController指定路由以及路由携带的参数
    [self.flutterViewController setInitialRoute:@"route1?{\"message\":\"嗨，本文案来自第一个原生页面，将在Flutter页面看到我\"}"];
    //初始化messageChannel，CHANNEL_NATIVE为iOS和Flutter两端统一的通信信号
    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NATIVE binaryMessenger:self.flutterViewController.binaryMessenger];
    //接受Flutter回调
    [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([call.method isEqualToString:@"openSecondNative"]) {
            //打开第二个原生页面
            NSLog(@"打开第二个原生页面");
            strongSelf.sMessageFromFlutter = call.arguments[@"message"];
            [strongSelf pushSecondNative];
            //告诉Flutter我们的处理结果
            if (result) {
                result(@"成功打开第二个原生页面");
            }
        }
        else if ([call.method isEqualToString:@"backFirstNative"]){
            //返回第一个原生页面
            NSLog(@"返回第一个原生页面");
            [strongSelf backFirstNative];
            strongSelf.lblTitle.text = call.arguments[@"message"];
            //告诉Flutter我们的处理结果
            if (result) {
                result(@"成功返回第一个原生页面");
            }
        }
    }];
    //设置模态跳转满屏显示
    self.flutterViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.flutterViewController animated:YES completion:nil];
}

- (void)configFlutterWithFlutterEngine{
    __weak __typeof(self) weakSelf = self;
    //初始化FlutterEngine
    FlutterEngine *flutterEngine = [[FlutterEngine alloc]initWithName:@"FirstFlutterViewController"];
    //指定路由打开某一页面，Flutter1.12版本指定路由后在Flutter代码里获取的路由统一为“/”,为Flutter bug
    [[flutterEngine navigationChannel] invokeMethod:@"setInitialRoute" arguments:@"route1?{\"message\":\"嗨，本文案来自第一个原生页面，将在Flutter页面看到我\"}"];
    //路由的指定需要在FlutterEngine run方法之前，run方法之后指定路由不管用
    [flutterEngine run];
    //使用FlutterEngine初始化FlutterViewController
    self.flutterViewController = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    //初始化messageChannel，CHANNEL_NATIVE为iOS和Flutter两端统一的通信信号
    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NATIVE binaryMessenger:flutterEngine.binaryMessenger];
    //接受Flutter回调
    [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([call.method isEqualToString:@"openSecondNative"]) {
            //打开第二个原生页面
            NSLog(@"打开第二个原生页面");
            strongSelf.sMessageFromFlutter = call.arguments[@"message"];
            [strongSelf pushSecondNative];
            //告诉Flutter我们的处理结果
            if (result) {
                result(@"成功打开第二个原生页面");
            }
        }
        else if ([call.method isEqualToString:@"backFirstNative"]){
            //返回第一个原生页面
            NSLog(@"返回第一个原生页面");
            [strongSelf backFirstNative];
            strongSelf.lblTitle.text = call.arguments[@"message"];
            //告诉Flutter我们的处理结果
            if (result) {
                result(@"成功返回第一个原生页面");
            }
        }
    }];
    //设置模态跳转满屏显示
    self.flutterViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.flutterViewController animated:YES completion:nil];
}

//打开第二个原生页面
- (void)pushSecondNative{
    SecondNativeViewController *secondNativeVC = [[SecondNativeViewController alloc]initWithNibName:@"SecondNativeViewController" bundle:nil];
    secondNativeVC.showMessage = self.sMessageFromFlutter;
    __weak __typeof(self) weakSelf = self;
    //第二个原生页面的block回调
    secondNativeVC.ReturnStrBlock = ^(NSString *message){
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //从第二个原生页面回来后通知Flutter页面更新文案
        [strongSelf sendMessageToFlutter:message];
    };
    secondNativeVC.modalPresentationStyle = UIModalPresentationFullScreen;
    //进行本操作时，当前屏幕的s控制器为FlutterViewController，所以应该使用self.flutterViewController进行跳转
    [self.flutterViewController presentViewController:secondNativeVC animated:YES completion:nil];
}

- (void)backFirstNative{
    //关闭Flutter页面
    [self.flutterViewController dismissViewControllerAnimated: YES completion: nil];
}

- (void)sendMessageToFlutter:(NSString *)message{
    //初始化messageChannel，CHANNEL_FLUTTER为iOS和Flutter两端统一的通信信号
    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:CHANNEL_FLUTTER binaryMessenger:self.flutterViewController.binaryMessenger];
    [messageChannel invokeMethod:@"onActivityResult" arguments:@{@"message":message}];
}
@end
