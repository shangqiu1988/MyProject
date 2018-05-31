//
//  UINavigationBar+NavigationBar.m
//  NewUXin
//
//  Created by tanpeng on 2017/11/3.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UINavigationBar+NavigationBar.h"
#import <objc/runtime.h>
static char kBackgroundViewKey;
static char kBackgroundImageViewKey;
static int kNavBarBottom = 64;
@implementation UINavigationBar (NavigationBar)
- (UIView *)backgroundView
{
    return (UIView *)objc_getAssociatedObject(self, &kBackgroundViewKey);
}
- (void)setBackgroundView:(UIView *)backgroundView
{
    objc_setAssociatedObject(self, &kBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)backgroundImageView
{
    return (UIImageView *)objc_getAssociatedObject(self, &kBackgroundImageViewKey);
}
- (void)setBackgroundImageView:(UIImageView *)bgImageView
{
    objc_setAssociatedObject(self, &kBackgroundImageViewKey, bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)customer_setBackgroundImage:(UIImage *)image
{
    [self.backgroundView removeFromSuperview];
    self.backgroundView=nil;
    if(self.backgroundImageView==nil){
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kNavBarBottom)];
            self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.subviews.firstObject insertSubview:self.backgroundImageView atIndex:0];
    }
    self.backgroundImageView.image=image;
}

-(void)customer_setBackgroundColor:(UIColor *)color
{
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    if (self.backgroundView == nil)
    {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kNavBarBottom)];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        // _UIBarBackground is first subView for navigationBar
        [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
    }
    self.backgroundView.backgroundColor = color;
}
- (void)customer_setBackgroundAlpha:(CGFloat)alpha
{
    UIView *barBackgroundView = self.subviews.firstObject;
    barBackgroundView.alpha = alpha;
}
-(void)setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator
{
    for (UIView *view in self.subviews)
    {
        if (hasSystemBackIndicator == YES)
        {
            // _UIBarBackground/_UINavigationBarBackground对应的view是系统导航栏，不需要改变其透明度
            Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
            if (_UIBarBackgroundClass != nil)
            {
                if ([view isKindOfClass:_UIBarBackgroundClass] == NO) {
                    view.alpha = alpha;
                }
            }
            
            Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
            if (_UINavigationBarBackground != nil)
            {
                if ([view isKindOfClass:_UINavigationBarBackground] == NO) {
                    view.alpha = alpha;
                }
            }
        }
        else
        {
            // 这里如果不做判断的话，会显示 backIndicatorImage
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")] == NO)
            {
                Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
                if (_UIBarBackgroundClass != nil)
                {
                    if ([view isKindOfClass:_UIBarBackgroundClass] == NO) {
                        view.alpha = alpha;
                    }
                }
                
                Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
                if (_UINavigationBarBackground != nil)
                {
                    if ([view isKindOfClass:_UINavigationBarBackground] == NO) {
                        view.alpha = alpha;
                    }
                }
            }
        }
    }
}
// 设置导航栏在垂直方向上平移多少距离
- (void)setTranslationY:(CGFloat)translationY
{
      self.transform = CGAffineTransformMakeTranslation(0, translationY);
}
/** 获取当前导航栏在垂直方向上偏移了多少 */
- (CGFloat)getTranslationY
{
        return self.transform.ty;
}
#pragma mark - call swizzling methods active 主动调用交换方法
+(void)load
{
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        SEL needSwizzleSelectors[1]={
            @selector(setTitleTextAttributes:)
        };
        for(NSInteger i=0;i<1;i++)
        {
            SEL selector=needSwizzleSelectors[i];
            NSString *newSelectorStr=[NSString stringWithFormat:@"customer_%@",NSStringFromSelector(selector)];
            Method originMethod=class_getInstanceMethod(self, selector);
            Method swizzledMethod=class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}
- (void)customer_setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes
{
    NSMutableDictionary<NSString *,id> *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    if (newTitleTextAttributes == nil) {
        return;
    }
    
    NSDictionary<NSString *,id> *originTitleTextAttributes = self.titleTextAttributes;
    if (originTitleTextAttributes == nil) {
        [self customer_setTitleTextAttributes:newTitleTextAttributes];
        return;
    }
     __block UIColor *titleColor;
    [originTitleTextAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqual:NSForegroundColorAttributeName]) {
            titleColor = (UIColor *)obj;
            *stop = YES;
        }
    }];
    
    if (titleColor == nil) {
        [self customer_setTitleTextAttributes:newTitleTextAttributes];
        return;
    }
    
    if (newTitleTextAttributes[NSForegroundColorAttributeName] == nil) {
        newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    }
    [self customer_setTitleTextAttributes:newTitleTextAttributes];
}
@end
