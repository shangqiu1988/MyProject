//
//  UXinParallaxScrollView.m
//  NewUXin
//
//  Created by tanpeng on 17/9/15.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinParallaxScrollView.h"
#import "UXinParallaxScrollViewDelegateForwarder.h"

static void * const kScrollViewKVOContext = (void*)&kScrollViewKVOContext;
@interface UXinParallaxScrollView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong) UXinParallaxScrollViewDelegateForwarder *forwarder;
@property(nonatomic,strong) NSMutableArray<UIScrollView *> *observedViews;
@end
@implementation UXinParallaxScrollView{
    BOOL _isOBserving;
    BOOL _lock;
}
@synthesize delegate=_delegate;
@synthesize bounces=_bounces;
-(void)dealloc
{
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize
{
    self.forwarder=[UXinParallaxScrollViewDelegateForwarder new];
    super.delegate=self.forwarder;
    self.showsVerticalScrollIndicator=NO;
    self.directionalLockEnabled=YES;
    self.panGestureRecognizer.cancelsTouchesInView=NO;
    self.observedViews=[NSMutableArray array];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:kScrollViewKVOContext];
    _isOBserving=YES;
}
#pragma mark Properties
-(void)setDelegate:(id<ParallaxScrollViewDelegate>)delegate
{
    self.forwarder.delegate=delegate;
    super.delegate=nil;
    super.delegate=self.forwarder;
}

-(id<ParallaxScrollViewDelegate>)delegate
{
    return self.forwarder.delegate;
}
#pragma mark <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark KVO
- (void)addObserverToView:(UIScrollView *)scrollView
{
    
}
- (void)removeObserverFromView:(UIScrollView *)scrollView
{
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}
#pragma mark Scrolling views handlers
- (void)addObservedView:(UIScrollView *)scrollView
{
    
}
- (void)removeObservedViews
{
    
}
- (void)scrollView:(UIScrollView *)scrollView setContentOffset:(CGPoint)offset
{
    
}
#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
