//
//  UXinSettingBaseController.m
//  NewUXin
//
//  Created by tanpeng on 17/9/12.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinSettingBaseController.h"

@interface UXinSettingBaseController ()

@end

@implementation UXinSettingBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //模板方法 子类去实现
    [self addCellViews];
    [self setCellViewFrame];
    [self setOnClickEvent];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-模板方法
-(void)addCellViews
{
    
}
-(void)setCellViewFrame
{
    
}
-(void)setOnClickEvent
{
    
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
