//
//  UIViewController+NavigationBar.m
//  NewUXin
//
//  Created by tanpeng on 2017/11/3.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>
#import "UINavigationBar+NavigationBar.h"
#import "UIColor+NavigationBar.h"
static char kPushToCurrentVCFinishedKey;
static char kPushToNextVCFinishedKey;
static char kNavBarBackgroundImageKey;
static char kNavBarBarTintColorKey;
static char kNavBarBackgroundAlphaKey;
static char kNavBarTintColorKey;
static char kNavBarTitleColorKey;
static char kStatusBarStyleKey;
static char kNavBarShadowImageHiddenKey;
static char kCustomNavBarKey;

@implementation UINavigationController(NaviagtorBar)
static CGFloat PopDuration = 0.12;
static int PopDisplayCount = 0;
-(CGFloat)PopProgress
{
    CGFloat all = 60 * PopDuration;
    int current = MIN(all, PopDisplayCount);
    return current / all;
}
static CGFloat PushDuration = 0.10;
static int PushDisplayCount = 0;
-(CGFloat)PushProgress
{
    CGFloat all = 60 * PushDuration;
    int current = MIN(all, PushDisplayCount);
    return current / all;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.topViewController customer_statusBarStyle];
}
- (void)setNeedsNavigationBarUpdateForBarBackgroundImage:(UIImage *)backgroundImage
{
     [self.navigationBar customer_setBackgroundImage:backgroundImage];
}
- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)barTintColor
{
       [self.navigationBar customer_setBackgroundColor:barTintColor];
}
- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)barBackgroundAlpha
{
    [self.navigationBar customer_setBackgroundAlpha:barBackgroundAlpha];
}
- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)tintColor
{
    self.navigationBar.tintColor=tintColor;
}
- (void)setNeedsNavigationBarUpdateForShadowImageHidden:(BOOL)hidden
{
     self.navigationBar.shadowImage = (hidden == YES) ? [UIImage new] : nil;
}
- (void)setNeedsNavigationBarUpdateForTitleColor:(UIColor *)titleColor
{
    NSDictionary *titleTextAttributes = [self.navigationBar titleTextAttributes];
    if (titleTextAttributes == nil) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
        return;
    }
    
    NSMutableDictionary *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    self.navigationBar.titleTextAttributes = newTitleTextAttributes;
}
- (void)updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress
{
    //change navBarbarTintColor
    UIColor *fromBarTintColor=[fromVC customer_navBarBarTintColor];
    UIColor *toBarTintColor=[toVC customer_navBarBarTintColor];
    UIColor *newBarTintColor=[UIColor middleColor:fromBarTintColor toColor:toBarTintColor percent:progress];
    
    [self setNeedsNavigationBarUpdateForBarTintColor:newBarTintColor];
    // change navBarTintColor
    UIColor *fromTintColor = [fromVC customer_navBarTintColor];
    UIColor *toTintColor = [toVC customer_navBarTintColor];
    UIColor *newTintColor = [UIColor middleColor:fromTintColor toColor:toTintColor percent:progress];
    [self setNeedsNavigationBarUpdateForTintColor:newTintColor];
    
    // change navBarTitleColor
    UIColor *fromTitleColor = [fromVC customer_navBarTitleColor];
    UIColor *toTitleColor = [toVC customer_navBarTitleColor];
    UIColor *newTitleColor = [UIColor middleColor:fromTitleColor toColor:toTitleColor percent:progress];
    [self setNeedsNavigationBarUpdateForTitleColor:newTitleColor];
    
    // change navBar _UIBarBackground alpha
    CGFloat fromBarBackgroundAlpha = [fromVC customer_navBarBackgroundAlpha];
    CGFloat toBarBackgroundAlpha = [toVC customer_navBarBackgroundAlpha];
    CGFloat newBarBackgroundAlpha = [UIColor middleAlpha:fromBarBackgroundAlpha toAlpha:toBarBackgroundAlpha percent:progress];
    [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:newBarBackgroundAlpha];
}
- (NSArray<UIViewController *> *)customer_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    __block CADisplayLink *displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink=nil;
        PopDisplayCount=0;
    } ];
    [CATransaction setAnimationDuration:PopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs=[self customer_popToViewController:viewController animated:animated];
    [CATransaction commit];
    return vcs;
}
- (NSArray<UIViewController *> *)customer_popToRootViewControllerAnimated:(BOOL)animated
{
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        PopDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:PopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self customer_popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return vcs;
}
- (void)popNeedDisplay
{
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil)
    {
        PopDisplayCount += 1;
        CGFloat popProgress = [self PopProgress];
        UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:popProgress];
    }
}
- (void)customer_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(pushNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        PushDisplayCount = 0;
        [viewController setPushToCurrentVCFinished:YES];
    }];
    [CATransaction setAnimationDuration:PushDuration];
    [CATransaction begin];
    [self customer_pushViewController:viewController animated:animated];
    [CATransaction commit];
}
- (void)pushNeedDisplay
{
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil)
    {
        PushDisplayCount += 1;
        CGFloat pushProgress = [self PushProgress];
        UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:pushProgress];
    }
}
#pragma mark - deal the gesture of return
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive] == YES)
    {
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if ([sysVersion floatValue] >= 10)
        {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        else
        {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    
    
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVC animated:YES];
    return YES;
}
- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context
{
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        UIColor *curColor = [[context viewControllerForKey:key] customer_navBarBarTintColor];
        CGFloat curAlpha = [[context viewControllerForKey:key] customer_navBarBackgroundAlpha];
        [self setNeedsNavigationBarUpdateForBarTintColor:curColor];
        [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:curAlpha];
    };
    
    // after that, cancel the gesture of return
    if ([context isCancelled] == YES)
    {
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        }];
    }
    else
    {
        // after that, finish the gesture of return
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextToViewControllerKey);
        }];
    }
}
- (void)customer_updateInteractiveTransition:(CGFloat)percentComplete
{
    UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:percentComplete];
    
    [self customer_updateInteractiveTransition:percentComplete];
}
#pragma mark - call swizzling methods active 主动调用交换方法
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      SEL needSwizzleSelectors[4] = {
                          NSSelectorFromString(@"_updateInteractiveTransition:"),
                          @selector(popToViewController:animated:),
                          @selector(popToRootViewControllerAnimated:),
                          @selector(pushViewController:animated:)
                      };
                      
                      for (int i = 0; i < 4;  i++) {
                          SEL selector = needSwizzleSelectors[i];
                          NSString *newSelectorStr = [[NSString stringWithFormat:@"customer_%@", NSStringFromSelector(selector)] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
                          Method originMethod = class_getInstanceMethod(self, selector);
                          Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
                          method_exchangeImplementations(originMethod, swizzledMethod);
                      }
                  });
}
@end
@implementation UIViewController (NavigationBar)
// navigationBar barTintColor can not change by currentVC before fromVC push to currentVC finished
- (BOOL)pushToCurrentVCFinished
{
    id isFinished = objc_getAssociatedObject(self, &kPushToCurrentVCFinishedKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}
- (void)setPushToCurrentVCFinished:(BOOL)isFinished
{
     objc_setAssociatedObject(self, &kPushToCurrentVCFinishedKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// navigationBar barTintColor can not change by currentVC when currentVC push to nextVC finished
- (BOOL)pushToNextVCFinished
{
    id isFinished = objc_getAssociatedObject(self, &kPushToNextVCFinishedKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}
- (void)setPushToNextVCFinished:(BOOL)isFinished
{
    objc_setAssociatedObject(self, &kPushToNextVCFinishedKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// navigationBar backgroundImage
- (UIImage *)customer_navBarBackgroundImage
{
    UIImage *image = (UIImage *)objc_getAssociatedObject(self, &kNavBarBackgroundImageKey);
    image = (image == nil) ? [UIColor defaultNavBarBackgroundImage] : image;
    return image;
}
- (void)customer_setNavBarBackgroundImage:(UIImage *)image
{
    if ([[self customer_customNavBar] isKindOfClass:[UINavigationBar class]])
    {
        UINavigationBar *navBar = (UINavigationBar *)[self customer_customNavBar];
        [navBar customer_setBackgroundImage:image];
    }
    else {
        objc_setAssociatedObject(self, &kNavBarBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
// navigationBar barTintColor
- (UIColor *)customer_navBarBarTintColor
{
    UIColor *barTintColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarBarTintColorKey);
    return (barTintColor != nil) ? barTintColor : [UIColor defaultNavBarBarTintColor];
}
- (void)customer_setNavBarBarTintColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &kNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self customer_customNavBar] isKindOfClass:[UINavigationBar class]])
    {
        UINavigationBar *navBar = (UINavigationBar *)[self customer_customNavBar];
        [navBar customer_setBackgroundColor:color];
    }
    else
    {
        if ([self pushToCurrentVCFinished] == YES && [self pushToNextVCFinished] == NO) {
            [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:color];
        }
    }
}
// navigationBar _UIBarBackground alpha
- (CGFloat)customer_navBarBackgroundAlpha
{
    id barBackgroundAlpha = objc_getAssociatedObject(self, &kNavBarBackgroundAlphaKey);
    return (barBackgroundAlpha != nil) ? [barBackgroundAlpha floatValue] : [UIColor defaultNavBarBackgroundAlpha];
}
- (void)customer_setNavBarBackgroundAlpha:(CGFloat)alpha
{
    objc_setAssociatedObject(self, &kNavBarBackgroundAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self customer_customNavBar] isKindOfClass:[UINavigationBar class]])
    {
        UINavigationBar *navBar = (UINavigationBar *)[self customer_customNavBar];
        [navBar customer_setBackgroundAlpha:alpha];
    }
    else
    {
        if ([self pushToCurrentVCFinished] == YES && [self pushToNextVCFinished] == NO) {
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:alpha];
        }
    }
}
- (void)customer_setNavBarTintColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &kNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self customer_customNavBar] isKindOfClass:[UINavigationBar class]])
    {
        UINavigationBar *navBar = (UINavigationBar *)[self customer_customNavBar];
        [navBar customer_setBackgroundColor:color];
    }
    else
    {
        if ([self pushToCurrentVCFinished] == YES && [self pushToNextVCFinished] == NO) {
            [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:color];
        }
    }
}
// navigationBar tintColor
- (UIColor *)customer_navBarTintColor
{
    UIColor *tintColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarTintColorKey);
    return (tintColor != nil) ? tintColor : [UIColor defaultNavBarTintColor];
}
// navigationBar titleColor
- (UIColor *)customer_navBarTitleColor
{
    UIColor *titleColor = (UIColor *)objc_getAssociatedObject(self, &kNavBarTitleColorKey);
    return (titleColor != nil) ? titleColor : [UIColor defaultNavBarTitleColor];
}
- (void)customer_setNavBarTitleColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &kNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self customer_customNavBar] isKindOfClass:[UINavigationBar class]])
    {
        UINavigationBar *navBar = (UINavigationBar *)[self customer_customNavBar];
        navBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    }
    else
    {
        if ([self pushToNextVCFinished] == NO) {
            [self.navigationController setNeedsNavigationBarUpdateForTitleColor:color];
        }
    }
}
// statusBarStyle
- (UIStatusBarStyle)customer_statusBarStyle
{
    id style = objc_getAssociatedObject(self, &kStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : [UIColor defaultStatusBarStyle];
}
- (void)customer_setStatusBarStyle:(UIStatusBarStyle)style
{
    objc_setAssociatedObject(self, &kStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}
// shadowImage
- (void)customer_setNavBarShadowImageHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, &kNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:hidden];
}
- (BOOL)customer_navBarShadowImageHidden
{
    id hidden = objc_getAssociatedObject(self, &kNavBarShadowImageHiddenKey);
    return (hidden != nil) ? [hidden boolValue] : [UIColor defaultNavBarShadowImageHidden];
}
// custom navigationBar
- (UIView *)customer_customNavBar
{
    UIView *navBar = objc_getAssociatedObject(self, &kCustomNavBarKey);
    return (navBar != nil) ? navBar : [UIView new];
}
- (void)customer_setCustomNavBar:(UINavigationBar *)navBar
{
    objc_setAssociatedObject(self, &kCustomNavBarKey, navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      SEL needSwizzleSelectors[3] = {
                          @selector(viewWillAppear:),
                          @selector(viewWillDisappear:),
                          @selector(viewDidAppear:)
                      };
                      
                      for (int i = 0; i < 3;  i++) {
                          SEL selector = needSwizzleSelectors[i];
                          NSString *newSelectorStr = [NSString stringWithFormat:@"customer_%@", NSStringFromSelector(selector)];
                          Method originMethod = class_getInstanceMethod(self, selector);
                          Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
                          method_exchangeImplementations(originMethod, swizzledMethod);
                      }
                  });
}
- (void)customer_viewWillAppear:(BOOL)animated
{
    if([self canUpdateNavigationBar]==YES){
        [self setPushToNextVCFinished:NO];
        [self.navigationController setNeedsNavigationBarUpdateForTintColor:self.customer_navBarTintColor];
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self customer_navBarTitleColor]];
        
    }
    [self customer_viewWillAppear:animated];
}
- (void)customer_viewWillDisappear:(BOOL)animated
{
    if([self canUpdateNavigationBar]==YES){
        
        [self setPushToNextVCFinished:YES];
    }
    [self customer_viewWillDisappear:animated];
}
- (void)customer_viewDidAppear:(BOOL)animated
{
    if([self canUpdateNavigationBar]==YES){
        UIImage *barBgImage=[self customer_navBarBackgroundImage];
        if(barBgImage!=nil){
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundImage:barBgImage];
        }else{
             [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:[self customer_navBarBarTintColor]];
          
        }
        [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:[self customer_navBarBackgroundAlpha]];
        [self.navigationController setNeedsNavigationBarUpdateForTintColor:[self customer_navBarTintColor]];
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self customer_navBarTitleColor]];
        [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:[self customer_navBarShadowImageHidden]];
    }
    
    [self customer_viewDidAppear:animated];
}
- (BOOL)canUpdateNavigationBar
{
    if(self.navigationController&&CGRectEqualToRect(self.view.frame, [UIScreen mainScreen].bounds)){
        return YES;
    }else{
        return NO;
    }
    return NO;
}
@end
