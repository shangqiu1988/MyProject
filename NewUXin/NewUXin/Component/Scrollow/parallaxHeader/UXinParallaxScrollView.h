//
//  UXinParallaxScrollView.h
//  NewUXin
//
//  Created by tanpeng on 17/9/15.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class UXinParallaxScrollView;
/**
 The delegate of a MXScrollView object may adopt the MXScrollViewDelegate protocol to control subview's scrolling effect.
 */
@protocol ParallaxScrollViewDelegate <UIScrollViewDelegate>

@optional
/**
 Asks the page if the scrollview should scroll with the subview.
 
 @param scrollView The scrollview. This is the object sending the message.
 @param subView    An instance of a sub view.
 
 @return YES to allow scrollview and subview to scroll together. YES by default.
 */
- (BOOL)scrollView:(UXinParallaxScrollView *)scrollView shouldScrollWithSubView:(UIScrollView *)subView;

@end

/**
 The UXinParallaxScrollView is a UIScrollView subclass with the ability to hook the vertical scroll from its subviews.
 */

@interface UXinParallaxScrollView : UIScrollView
@property (nonatomic, assign)  id<ParallaxScrollViewDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
