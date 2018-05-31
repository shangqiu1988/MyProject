//
//  UXinValueTrackingSlider.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/9.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UXinValueTrackingSliderDelegate;
@protocol UXinValueTrackingSliderDataSource;
@interface UXinValueTrackingSlider : UISlider
// present the popupview manually, without touch event.
- (void)showPopUpView;
// the popupview will not hide again until you call 'hidePopUpView'
- (void)hidePopUpView;
@property (strong, nonatomic) UIColor *textColor;
// font can not be nil, it must be a valid UIFont
// default is ‘boldSystemFontOfSize:22.0’
@property (strong, nonatomic) UIFont *font;

// setting the value of 'popUpViewColor' overrides 'popUpViewAnimatedColors' and vice versa
// the return value of 'popUpViewColor' is the currently displayed value
// this will vary if 'popUpViewAnimatedColors' is set (see below)
@property (strong, nonatomic) UIColor *popUpViewColor;

// pass an array of 2 or more UIColors to animate the color change as the slider moves
@property (strong, nonatomic) NSArray *popUpViewAnimatedColors;

// the above @property distributes the colors evenly across the slider
// to specify the exact position of colors on the slider scale, pass an NSArray of NSNumbers
- (void)setPopUpViewAnimatedColors:(NSArray *)popUpViewAnimatedColors withPositions:(NSArray *)positions;

// cornerRadius of the popUpView, default is 4.0
@property (nonatomic) CGFloat popUpViewCornerRadius;

// changes the left handside of the UISlider track to match current popUpView color
// the track color alpha is always set to 1.0, even if popUpView color is less than 1.0
@property (nonatomic) BOOL autoAdjustTrackColor; // (default is YES)

// when setting max FractionDigits the min value is automatically set to the same value
// this ensures that the PopUpView frame maintains a consistent width
- (void)setMaxFractionDigitsDisplayed:(NSUInteger)maxDigits;

// take full control of the format dispayed with a custom NSNumberFormatter
@property (copy, nonatomic) NSNumberFormatter *numberFormatter;

// supply entirely customized strings for slider values using the datasource protocol - see below
@property (weak, nonatomic) id<UXinValueTrackingSliderDataSource> dataSource;

// delegate is only needed when used with a TableView or CollectionView - see below
@property (weak, nonatomic) id<UXinValueTrackingSliderDelegate> delegate;
@end
// to supply custom text to the popUpView label, implement <ASValueTrackingSliderDataSource>
// the dataSource will be messaged each time the slider value changes
@protocol UXinValueTrackingSliderDataSource <NSObject>
- (NSString *)slider:(UXinValueTrackingSlider *)slider stringForValue:(float)value;
@end

// when embedding an ASValueTrackingSlider inside a TableView or CollectionView
// you need to ensure that the cell it resides in is brought to the front of the view hierarchy
// to prevent the popUpView from being obscured
@protocol UXinValueTrackingSliderDelegate <NSObject>


@optional
- (void)sliderDidHidePopUpView:(UXinValueTrackingSlider *)slider;
- (void)sliderWillDisplayPopUpView:(UXinValueTrackingSlider *)slider;
@end
