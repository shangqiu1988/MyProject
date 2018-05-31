//
//  UXinPopupMenu.h
//  NewUXin
//
//  Created by tanpeng on 17/8/14.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , PopupMenuType) {
    PopupMenuTypeDefault = 0,
    PopupMenuTypeDark
};

@class UXinPopupMenu;

@protocol PopupMenuDelegate <NSObject>
@optional
/**
 点击回调事件
 */
-(void)popUpMenuDidSelectedAtIndex:(NSInteger)index popUpMenu:(UXinPopupMenu *)menu;
-(void)popUpMenyBeganDismiss;
-(void)popUpMenuDidDismiss;
@end
typedef void  (^popUpMenuDidSelected)(NSInteger index);
typedef void  (^popUpMenuBeganDismiss)();
typedef void   (^popUpMenuDidDismiss)();
@interface UXinPopupMenu : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UIView * _mainView;
    UITableView * _contentView;
    UIView * _bgView;
    
    CGPoint _anchorPoint;
    
    CGFloat kArrowHeight;
    CGFloat kArrowWidth;
    CGFloat kArrowPosition;
    CGFloat kButtonHeight;
    
    NSArray * _titles;
    NSArray * _icons;
    
    UIColor * _contentColor;
    UIColor * _separatorColor;

}
/**
 block
 */
@property(nonatomic,copy) popUpMenuDidSelected selectedBlock;
@property(nonatomic,copy) popUpMenuBeganDismiss beginDismissBlock;
@property(nonatomic,copy) popUpMenuDidDismiss didDismissBlock;
/**
 圆角半径 Default is 5.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 是否显示阴影 Default is YES
 */
@property (nonatomic, assign , getter=isShadowShowing) BOOL isShowShadow;

/**
 选择菜单项后消失 Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnSelected;

/**
 点击菜单外消失  Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnTouchOutside;

/**
 设置字体大小 Default is 15
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 设置字体颜色 Default is [UIColor blackColor]
 */
@property (nonatomic, strong) UIColor * textColor;

/**
 设置偏移距离 (>= 0) Default is 0.0
 */
@property (nonatomic, assign) CGFloat offset;

/**
 设置显示模式 Default is YBPopupMenuTypeDefault
 */
@property (nonatomic, assign) PopupMenuType type;

/**
 代理
 */
@property (nonatomic, assign) id <PopupMenuDelegate> delegate;

/**
 在指定位置弹出类方法
 
 @param titles    标题数组
 @param icons     图标数组
 @param itemWidth 菜单宽度
 @param delegate  代理
 */
+ (instancetype)showAtPoint:(CGPoint)point
                     titles:(NSArray *)titles
                      icons:(NSArray *)icons
                  menuWidth:(CGFloat)itemWidth
                   delegate:(id<PopupMenuDelegate>)delegate;


/**
 依赖指定view弹出类方法
 
 @param titles    标题数组
 @param icons     图标数组
 @param itemWidth 菜单宽度
 @param delegate  代理
 */
+ (instancetype)showRelyOnView:(UIView *)view
                        titles:(NSArray *)titles
                         icons:(NSArray *)icons
                     menuWidth:(CGFloat)itemWidth
                      delegate:(id<PopupMenuDelegate>)delegate;

/**
 block
 依赖指定view弹出类方法
 
 @param titles    标题数组
 @param icons     图标数组
 @param itemWidth 菜单宽度
 @param selectedHandle 选中 回调
 @param beginDismisshandle 开始消失 回调
 @param didDismissHandle 完全消失回调
 */
+(instancetype)showAtPoint:(CGPoint)point
                    titles:(NSArray *)titles
                     icons:(NSArray *)icons
                 menuWidth:(CGFloat)itemWidth
            selectedHandle:(popUpMenuDidSelected)selectedHandle
        beginDismisshandle:(popUpMenuBeganDismiss)beginDismisshandle
          didDismissHandle:(popUpMenuDidDismiss)didDismissHandle;
/**
 block
 依赖指定view弹出类方法
 
 @param titles    标题数组
 @param icons     图标数组
 @param itemWidth 菜单宽度
 @param selectedHandle 选中 回调
 @param beginDismisshandle 开始消失 回调
 @param didDismissHandle 完全消失回调
 */
+ (instancetype)showRelyOnView:(UIView *)view
                        titles:(NSArray *)titles
                         icons:(NSArray *)icons
                     menuWidth:(CGFloat)itemWidth
                selectedHandle:(popUpMenuDidSelected)selectedHandle
            beginDismisshandle:(popUpMenuBeganDismiss)beginDismisshandle
              didDismissHandle:(popUpMenuDidDismiss)didDismissHandle;
/**
 初始化
 */
-(void)setUp;
/**
 消失
 */
- (void)dismiss;

@end
