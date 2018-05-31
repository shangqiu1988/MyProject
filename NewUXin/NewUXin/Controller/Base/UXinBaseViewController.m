//
//  UXinBaseViewController.m
//  NewUXin
//
//  Created by tanpeng on 17/8/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinBaseViewController.h"

@interface UXinBaseViewController ()

@end

@implementation UXinBaseViewController
-(void)dealloc
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(238, 238, 238, 1.0);
    hud=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-public
-(void)showHud:(BOOL)isAnimation
{
    [self.view bringSubviewToFront:hud];
    [hud showAnimated:isAnimation];
}
-(void)hideHud:(BOOL)isAnimation
{
    [hud hideAnimated:isAnimation];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
