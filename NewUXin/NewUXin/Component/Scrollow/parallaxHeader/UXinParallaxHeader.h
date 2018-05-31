//
//  UXinParallaxHeader.h
//  NewUXin
//
//  Created by tanpeng on 17/9/15.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/**
 The parallac header mode.
 */
typedef NS_ENUM(NSInteger, ParallaxHeaderMode) {
    /**
     The option to scale the content to fill the size of the header. Some portion of the content may be clipped to fill the header’s bounds.
     */
    ParallaxHeaderModeFill = 0,
    /**
     The option to scale the content to fill the size of the header and aligned at the top in the header's bounds.
     */
    ParallaxHeaderModeTopFill,
    /**
     The option to center the content aligned at the top in the header's bounds.
     */
    ParallaxHeaderModeTop,
    /**
     The option to center the content in the header’s bounds, keeping the proportions the same.
     */
    ParallaxHeaderModeCenter,
    /**
     The option to center the content aligned at the bottom in the header’s bounds.
     */
    ParallaxHeaderModeBottom
};
@protocol ParallaxHeaderDelegate;
@interface UXinParallaxHeader : NSObject
/**
 The content view on top of the UIScrollView's content.
 */
@property (nonatomic,readonly) UIView *contentView;

/**
 Delegate instance that adopt the MXScrollViewDelegate.
 */
@property (nonatomic,assign)  id<ParallaxHeaderDelegate> delegate;

/**
 The header's view.
 */
@property (nonatomic,strong,nullable)  UIView *view;

/**
 The header's default height. 0 0 by default.
 */
@property (nonatomic,assign)  CGFloat height;

/**
 The header's minimum height while scrolling up. 0 by default.
 */
@property (nonatomic,assign)  CGFloat minimumHeight;

/**
 The parallax header behavior mode.
 */
@property (nonatomic,assign) ParallaxHeaderMode mode;

/**
 The parallax header progress value.
 */
@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,weak) UIScrollView *scrollView;
@end
/**
 The method declared by the MXParallaxHeaderDelegate protocol allow the adopting delegate to respond to scoll from the MXParallaxHeader class.
 */
@protocol ParallaxHeaderDelegate <NSObject>

@optional

/**
 Tells the header view that the parallax header did scroll.
 The view typically implements this method to obtain the change in progress from parallaxHeaderView.
 
 @param parallaxHeader The parallax header that scrolls.
 */
- (void)parallaxHeaderDidScroll:(UXinParallaxHeader *)parallaxHeader;

@end

NS_ASSUME_NONNULL_END
