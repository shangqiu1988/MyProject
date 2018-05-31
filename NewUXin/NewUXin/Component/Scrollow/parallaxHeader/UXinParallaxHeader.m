//
//  UXinParallaxHeader.m
//  NewUXin
//
//  Created by tanpeng on 17/9/15.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinParallaxHeader.h"
#import "UXinParallaxView.h"
@interface UXinParallaxHeader()
{
    BOOL _isObserving;
}

@end
@implementation UXinParallaxHeader
@synthesize contentView = _contentView;
#pragma mark Properties

- (UIView *)contentView {
    if (_contentView) {
        UXinParallaxView *contentView = [UXinParallaxView new];
        contentView.parent = self;
        contentView.clipsToBounds = YES;
        _contentView = contentView;
    }
    return _contentView;
}

- (void)setView:(UIView *)view {
    if (view != _view) {
        _view = view;
        [self updateConstraints];
    }
}
- (void)setMode:(ParallaxHeaderMode)mode {
    if (_mode != mode) {
        _mode = mode;
        [self updateConstraints];
    }
}
- (void)setHeight:(CGFloat)height
{
    if(_height!=height){
        [self adjustScrollViewTopInset:self.scrollView.contentInset.top-_height+height];
        _height=height;
        [self updateConstraints];
        [self layoutContentView];
    }
}
- (void)setMinimumHeight:(CGFloat)minimumHeight
{
    _minimumHeight=minimumHeight;
    [self layoutContentView];
}
- (void)setScrollView:(UIScrollView *)scrollView
{
    if(_scrollView!=scrollView){
        _scrollView=scrollView;
        [self adjustScrollViewTopInset:scrollView.contentInset.top+self.height];
        [scrollView addSubview:self.contentView];
        [self layoutContentView];
        _isObserving=YES;
    }
}
- (void)setProgress:(CGFloat)progress
{
    if(_progress!=progress){
        _progress=progress;
        if([self.delegate respondsToSelector:@selector(parallaxHeaderDidScroll:)]){
            [self.delegate parallaxHeaderDidScroll:self];
        }
    }
}
#pragma mark Constraints
- (void)updateConstraints
{
    if (!self.view) {
        return;
    }
    
    [self.view removeFromSuperview];
    [self.contentView addSubview:self.view];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    switch (self.mode) {
        case ParallaxHeaderModeFill:
            [self setFillModeConstraints];
            break;
            
        case ParallaxHeaderModeTopFill:
            [self setTopFillModeConstraints];
            break;
            
        case ParallaxHeaderModeTop:
            [self setTopModeConstraints];
            break;
            
        case ParallaxHeaderModeBottom:
            [self setBottomModeConstraints];
            break;
            
        default:
            [self setCenterModeConstraints];
            break;
    }
}
- (void)setFillModeConstraints
{
    NSDictionary *binding = @{@"v" : self.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:binding]];
}
- (void)setCenterModeConstraints
{
    
    NSDictionary *binding = @{@"v" : self.view};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:self.height]];

}
- (void)setTopFillModeConstraints
{
    NSDictionary *binding = @{@"v" : self.view};
    NSDictionary *metrics = @{@"highPriority" : @(UILayoutPriorityDefaultHigh),
                              @"height"       : @(self.height)};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v(>=height)]-0.0@highPriority-|" options:0 metrics:metrics views:binding]];
}
- (void)setTopModeConstraints
{
    NSDictionary *binding = @{@"v" : self.view};
    NSDictionary *metrics = @{@"height" : @(self.height)};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v(==height)]" options:0 metrics:metrics views:binding]];
}
- (void)setBottomModeConstraints
{
    NSDictionary *binding = @{@"v" : self.view};
    NSDictionary *metrics = @{@"height" : @(self.height)};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:binding]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v(==height)]|" options:0 metrics:metrics views:binding]];
}
#pragma mark Private Methods
- (void)layoutContentView
{
    CGFloat minimumHeight = MIN(self.minimumHeight, self.height);
    CGFloat relativeYOffset = self.scrollView.contentOffset.y + self.scrollView.contentInset.top - self.height;
    CGFloat relativeHeight  = -relativeYOffset;
    
    CGRect frame = (CGRect){
        .origin.x       = 0,
        .origin.y       = relativeYOffset,
        .size.width     = self.scrollView.frame.size.width,
        .size.height    = MAX(relativeHeight, minimumHeight)
    };
    
    self.contentView.frame = frame;
    
    CGFloat div = self.height - self.minimumHeight;
    self.progress = (self.contentView.frame.size.height - self.minimumHeight) / (div? : self.height);

}
- (void)adjustScrollViewTopInset:(CGFloat)top
{
    UIEdgeInsets inset = self.scrollView.contentInset;
    
    //Adjust content offset
    CGPoint offset = self.scrollView.contentOffset;
    offset.y += inset.top - top;
    self.scrollView.contentOffset = offset;
    
    //Adjust content inset
    inset.top = top;
    self.scrollView.contentInset = inset;

}
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kParallaxHeaderKVOContext) {
        
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
            [self layoutContentView];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}
@end
