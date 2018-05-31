//
//  UXinValueTrackingSlider.m
//  NewUXin
//
//  Created by tanpeng on 2018/1/9.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinValueTrackingSlider.h"
#import "UXinValuePopUpView.h"
static void * ValueTrackingSliderBoundsContext = &ValueTrackingSliderBoundsContext;
@interface UXinValueTrackingSlider() <UXinValuePopUpViewDelegate>
@property (strong, nonatomic) UXinValuePopUpView *popUpView;
@property (nonatomic) BOOL popUpViewAlwaysOn; // (default is NO)

@end
@implementation UXinValueTrackingSlider
{
    NSNumberFormatter *_numberFormatter;
    CGSize _defaultPopUpViewSize; // size that fits largest string from _numberFormatter
    CGSize _popUpViewSize; // usually == _defaultPopUpViewSize, but can vary if dataSource is used
    UIColor *_popUpViewColor;
    NSArray *_keyTimes;
    CGFloat _valueRange;
}
#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}
#pragma mark - public
- (void)showPopUpView
{
    self.popUpViewAlwaysOn = YES;
    [self _showPopUpView];
}
- (void)hidePopUpView
{
    self.popUpViewAlwaysOn = NO;
    [self.popUpView hide];
}
-(void)setAutoAdjustTrackColor:(BOOL)autoAdjustTrackColor
{
    if (_autoAdjustTrackColor == autoAdjustTrackColor) return;
    
    _autoAdjustTrackColor = autoAdjustTrackColor;
    
    // setMinimumTrackTintColor has been overridden to also set autoAdjustTrackColor to NO
    // therefore super's implementation must be called to set minimumTrackTintColor
    if (autoAdjustTrackColor == NO) {
        super.minimumTrackTintColor = nil; // sets track to default blue color
    } else {
        super.minimumTrackTintColor = [self.popUpView opaqueColor];
    }
}
-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self.popUpView setTextColor:textColor];
}
-(void)setFont:(UIFont *)font
{
    _font = font;
    [self.popUpView setFont:font];
    
    [self calculatePopUpViewSize];
}
- (void)_showPopUpView
{
    if (self.delegate) {
        [self.delegate sliderWillDisplayPopUpView:self];
    }
    [self positionAndUpdatePopUpView];
    [self.popUpView show];
}
// return the currently displayed color if possible, otherwise return _popUpViewColor
// if animated colors are set, the color will change each time the slider value changes
- (UIColor *)popUpViewColor
{
      return [self.popUpView color] ?: _popUpViewColor;
}

- (void)setPopUpViewColor:(UIColor *)popUpViewColor
{
    _popUpViewColor = popUpViewColor;
    _popUpViewAnimatedColors = nil; // animated colors should be discarded
    [self.popUpView setColor:popUpViewColor];
    
    if (_autoAdjustTrackColor) {
        super.minimumTrackTintColor = [self.popUpView opaqueColor];
    }
}
#pragma mark - ValuePopUpViewDelegate
-(void)colorAnimationDidStart
{
      [self autoColorTrack];
}
-(void)popUpViewDidHide
{
    if ([self.delegate respondsToSelector:@selector(sliderDidHidePopUpView:)]) {
        [self.delegate sliderDidHidePopUpView:self];
    }
}
-(CGFloat)currentValueOffset
{
      return (self.value + ABS(self.minimumValue)) / _valueRange;
}
#pragma mark - private
-(void)setup
{
    _autoAdjustTrackColor=YES;
    _valueRange=self.maximumValue-self.minimumValue;
    _popUpViewAlwaysOn=NO;
    
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    _numberFormatter = formatter;
    self.popUpView = [[UXinValuePopUpView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.popUpViewColor = [UIColor colorWithHue:0.6 saturation:0.6 brightness:0.5 alpha:0.8];
    
    self.popUpViewCornerRadius = 4.0;
    self.popUpView.alpha = 0.0;
    self.popUpView.delegate = self;
    [self addSubview:self.popUpView];
    
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont boldSystemFontOfSize:22.0f];
    [self positionAndUpdatePopUpView];
}
-(void)positionAndUpdatePopUpView
{
    NSString *valueString;
    if((valueString = [self.dataSource slider:self stringForValue:self.value])){
        _popUpViewSize =[self.popUpView popUpSizeForString:valueString];
    }else{
        valueString=[_numberFormatter stringFromNumber:@(self.value)];
        _popUpViewSize=_defaultPopUpViewSize;
    }
    [self adjustPopUpViewFrame];
    [self.popUpView setString:valueString];
    [self.popUpView setAnimationOffset:[self currentValueOffset]];
    [self autoColorTrack];
}
- (void)setPopUpViewAnimatedColors:(NSArray *)popUpViewAnimatedColors
{
     [self setPopUpViewAnimatedColors:popUpViewAnimatedColors withPositions:nil];
}
- (void)setPopUpViewAnimatedColors:(NSArray *)popUpViewAnimatedColors withPositions:(NSArray *)positions;
{
    if (positions) {
        NSAssert([popUpViewAnimatedColors count] == [positions count], @"popUpViewAnimatedColors and locations should contain the same number of items");
    }
    
    _popUpViewAnimatedColors = popUpViewAnimatedColors;
    _keyTimes = [self keyTimesFromSliderPositions:positions];
    
    if ([popUpViewAnimatedColors count] >= 2) {
        [self.popUpView setAnimatedColors:popUpViewAnimatedColors withKeyTimes:_keyTimes];
    } else {
        [self setPopUpViewColor:[popUpViewAnimatedColors lastObject] ?: _popUpViewColor];
    }
}
- (void)setPopUpViewCornerRadius:(CGFloat)popUpViewCornerRadius
{
    _popUpViewCornerRadius = popUpViewCornerRadius;
    [self.popUpView setCornerRadius:popUpViewCornerRadius];
}
- (void)setNumberFormatter:(NSNumberFormatter *)numberFormatter
{
    _numberFormatter = [numberFormatter copy];
    [self calculatePopUpViewSize];
}
- (NSNumberFormatter *)numberFormatter
{
     return [_numberFormatter copy]; //
}
- (void)adjustPopUpViewFrame
{
    
}
- (void)autoColorTrack
{
    if (_autoAdjustTrackColor == NO || !_popUpViewAnimatedColors) return;
    
    super.minimumTrackTintColor = [self.popUpView opaqueColor];
}
- (void)calculatePopUpViewSize
{
    CGSize minValSize = [self.popUpView popUpSizeForString:[_numberFormatter stringFromNumber:@(self.minimumValue)]];
    CGSize maxValSize = [self.popUpView popUpSizeForString:[_numberFormatter stringFromNumber:@(self.maximumValue)]];
    
    _defaultPopUpViewSize = (minValSize.width >= maxValSize.width) ? minValSize : maxValSize;
    _popUpViewSize = _defaultPopUpViewSize;
}
- (NSArray *)keyTimesFromSliderPositions:(NSArray *)positions
{
    if (!positions) return nil;
    
    NSMutableArray *keyTimes = [NSMutableArray array];
    for (NSNumber *num in [positions sortedArrayUsingSelector:@selector(compare:)]) {
        [keyTimes addObject:@((num.floatValue + ABS(self.minimumValue)) / _valueRange)];
    }
    return keyTimes;
}

#pragma mark-notification
-(void)didBecomeActiveNotification:(NSNotification *)notification
{
    if (self.popUpViewAnimatedColors) {
        [self.popUpView setAnimatedColors:_popUpViewAnimatedColors withKeyTimes:_keyTimes];
    }
}
#pragma mark - subclassed
- (CGRect)thumbRect
{
    return [self thumbRectForBounds:self.bounds
                          trackRect:[self trackRectForBounds:self.bounds]
                              value:self.value];
}
-(void)didMoveToWindow
{
    if (!self.window) { // removed from window - cancel notifications
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeObserver:self forKeyPath:@"bounds"];
    }
    else { // added to window - register notifications and observers
        
        if (self.popUpViewAnimatedColors) { // restart color animation if needed
            [self.popUpView setAnimatedColors:_popUpViewAnimatedColors withKeyTimes:_keyTimes];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [self addObserver:self forKeyPath:@"bounds"
                  options:NSKeyValueObservingOptionNew
                  context:ValueTrackingSliderBoundsContext];
    }
}
-(void)setValue:(float)value
{
    [super setValue:value];
    if (self.popUpViewAlwaysOn) [self positionAndUpdatePopUpView];
}
-(void)setValue:(float)value animated:(BOOL)animated
{
    [super setValue:value animated:animated];
    [self positionAndUpdatePopUpView];
}
- (void)setMaximumValue:(float)maximumValue
{
    [super setMaximumValue:maximumValue];
    _valueRange=self.maximumValue-self.minimumValue;
    [self calculatePopUpViewSize];
    
}
- (void)setMinimumValue:(float)minimumValue
{
    [super setMinimumValue:minimumValue];
    _valueRange = self.maximumValue - self.minimumValue;
    [self calculatePopUpViewSize];
}
- (void)setMaxFractionDigitsDisplayed:(NSUInteger)maxDigits
{
    [_numberFormatter setMaximumFractionDigits:maxDigits];
    [_numberFormatter setMinimumFractionDigits:maxDigits];
    [self calculatePopUpViewSize];
}

- (void)setMinimumTrackTintColor:(UIColor *)color
{
    self.autoAdjustTrackColor = NO; // if a custom value is set then prevent auto coloring
    [super setMinimumTrackTintColor:color];
}
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL begin =[super beginTrackingWithTouch:touch withEvent:event];
    if(begin){
        [self _showPopUpView];
    }
    return begin;
}
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL continueTrack =[super continueTrackingWithTouch:touch withEvent:event];
    if(continueTrack){
        [self positionAndUpdatePopUpView];
    }
    return continueTrack;
}
-(void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
    if(self.popUpViewAlwaysOn == NO){
        [self.popUpView hide];
    }
}
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self positionAndUpdatePopUpView];
    if (self.popUpViewAlwaysOn == NO) [self.popUpView hide];
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ValueTrackingSliderBoundsContext) {
        if (self.popUpViewAlwaysOn) {
            [self positionAndUpdatePopUpView];
            if (self.popUpViewAnimatedColors) {
                [self.popUpView setAnimatedColors:_popUpViewAnimatedColors withKeyTimes:_keyTimes];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
