//
//  ViewController.h
//  ios_app
//
//  Created by fly on 2020/3/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
- (IBAction)didPressedBtnOpen:(id)sender;


@end

