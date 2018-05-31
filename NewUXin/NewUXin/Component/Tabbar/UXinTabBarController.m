//
//  UXinTabBarController.m
//  NewUXin
//
//  Created by tanpeng on 2017/10/23.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinTabBarController.h"
#import "UXinTabBar.h"
#import "UXinTabBarItem.h"

@interface UXinTabBarController ()
@property(nonatomic,strong) UXinTabBar *UXTabBar;
@end

@implementation UXinTabBarController

- (void)loadView {
    
    [super loadView];
    
    self.itemImageRatio = 0.70f;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar addSubview:({
        UXinTabBar *tabbar=[[UXinTabBar alloc] init];
        tabbar.frame=self.tabBar.bounds;
        self.UXTabBar=tabbar;
    })];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self removeOriginControls];
}
-(void)removeOriginControls
{
    [self.tabBar.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIControl class]]){
            [obj removeFromSuperview];
        }
    }];
}
-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    self.UXTabBar.badgeTitleFont         = self.badgeTitleFont;
    self.UXTabBar.itemTitleFont          = self.itemTitleFont;
    self.UXTabBar.itemImageRatio         = self.itemImageRatio;
    self.UXTabBar.itemTitleColor         = self.itemTitleColor;
    self.UXTabBar.selectedItemTitleColor = self.selectedItemTitleColor;
      self.UXTabBar.tabBarItemCount = viewControllers.count;
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIViewController *VC = (UIViewController *)obj;
        
        UIImage *selectedImage = VC.tabBarItem.selectedImage;
        VC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self addChildViewController:VC];
        
        [self.UXTabBar addTabBarItem:VC.tabBarItem];
    }];
}
-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-get
-(UIColor *)itemTitleColor
{
    if(!_itemTitleColor){
        _itemTitleColor= [UIColor colorWithRed:117/255.0f green:117/255.0f blue:117/255.0f alpha:1.0f];
    }
    return _itemTitleColor;
}
-(UIColor *)selectedItemTitleColor
{
    if(!_selectedItemTitleColor){
        _selectedItemTitleColor= [UIColor colorWithRed:234/255.0f green:103/255.0f blue:7/255.0f alpha:1.0f];
    }
    return _selectedItemTitleColor;
}
- (UIFont *)itemTitleFont {
    
    if (!_itemTitleFont) {
        
        _itemTitleFont = [UIFont systemFontOfSize:10.0f];
    }
    return _itemTitleFont;
}

- (UIFont *)badgeTitleFont {
    
    if (!_badgeTitleFont) {
        
        _badgeTitleFont = [UIFont systemFontOfSize:11.0f];
    }
    return _badgeTitleFont;
}
#pragma mark - TabBarDelegate Method

- (void)tabBar:(UXinTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    self.selectedIndex = to;
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
