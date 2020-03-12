//
//  FirstNativeViewController.h
//  ios_app
//
//  Created by fly on 2020/3/11.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirstNativeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)didOressedBtnPushFlutter:(id)sender;
- (IBAction)didPressedBack:(id)sender;
@property (nonatomic, copy) NSString *showMessage;
@property (nonatomic, copy) void(^ReturnStrBlock)(NSString *message);
@end

NS_ASSUME_NONNULL_END
