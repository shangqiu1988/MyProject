//
//  EmptyDataSetDefine.h
//  NewUXin
//
//  Created by tanpeng on 2017/11/2.
//  Copyright © 2017年 Study. All rights reserved.
//
NS_ASSUME_NONNULL_BEGIN
static char const * const kEmptyDataSetSource =     "emptyDataSetSource";
static char const * const kEmptyDataSetDelegate =   "emptyDataSetDelegate";
static char const * const kEmptyDataSetView =       "emptyDataSetView";
#define DZNEmptyDataSetDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")
#define kEmptyImageViewAnimationKey @"com.uxin.emptyDataSet.imageViewAnimation"
@protocol EmptyDataSetSource <NSObject>
@optional
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
- (nullable NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;
- (nullable UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView;
- (nullable CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView;
- (nullable NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;
- (nullable UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;
- (nullable UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;
- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;
- (nullable UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView;
- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-verticalOffsetForEmptyDataSet:);
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView;
@end
@protocol EmptyDataSetDelegate <NSObject>
@optional
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView;
- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView;
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView;
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView;
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView;
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-emptyDataSet:didTapView:);
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView DZNEmptyDataSetDeprecated(-emptyDataSet:didTapButton:);

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView;
- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView;
- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView;
- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView;
@end
#undef DZNEmptyDataSetDeprecated
NS_ASSUME_NONNULL_END
