//
//  UXinBaseViewController.h
//  NewUXin
//
//  Created by tanpeng on 17/8/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface UXinBaseViewController : UIViewController
{
    MBProgressHUD *hud;
}
-(void)showHud:(BOOL)isAnimation;
-(void)hideHud:(BOOL)isAnimation;
@end
