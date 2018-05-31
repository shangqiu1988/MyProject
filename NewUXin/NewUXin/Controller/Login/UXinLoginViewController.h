//
//  UXinLoginViewController.h
//  NewUXin
//
//  Created by tanpeng on 17/8/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinBaseViewController.h"
#import <BRPickerView/BRPickerView.h>
#import "NSString+Common.h"
#import "UXinUserEntity.h"
typedef void (^loginFinished)();
@interface UXinLoginViewController : UXinBaseViewController
{
    
}
@property(nonatomic,strong)UITextField *accountField;

@property(nonatomic,strong)UITextField *passwordField;

@property(nonatomic,strong)UIButton *loginBtn;

@property(nonatomic,strong) UIButton *registerBtn;
@property(nonatomic,assign) BOOL isNeedShowPicker;

/**
 *  遮眼睛效果 （默认遮住眼睛）
 */
-(void)selectArea;


@end
