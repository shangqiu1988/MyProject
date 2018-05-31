//
//  UXinSettingBaseController.h
//  NewUXin
//
//  Created by tanpeng on 17/9/12.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinBaseViewController.h"
#import "UXinSettingCellView.h"
@interface UXinSettingBaseController : UXinBaseViewController
@property(nonatomic,strong) UIScrollView *containerView;
-(void)addCellViews;
-(void)setCellViewFrame;
-(void)setOnClickEvent;
@end
