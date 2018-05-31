//
//  UXinPhotoBrowserManager.m
//  NewUXin
//
//  Created by tanpeng on 2018/2/11.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinPhotoBrowserManager.h"
#if __has_include(<SDWebImage/SDWebImageManager.h>)

#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+MultiFormat.h>

#else

#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"
#endif

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

static UXinPhotoBrowserManager *mgr = nil;
static inline void resetManagerData(UXinPhotoBrowserView *photoBrowseView, PhotoUrlsMutableArray *urls ,PhotoFramesMutableArray *frames, PhotoImagesMutableArray *images) {
    [urls removeAllObjects];
    [frames removeAllObjects];
    [images removeAllObjects];
    if (photoBrowseView) {
        [photoBrowseView removeFromSuperview];
    }
}

@interface UXinPhotoBrowserManager(){
    
    NSOperationQueue *_requestQueue;
    dispatch_semaphore_t _lock;
}
@property (nonatomic , copy)void (^titleClickBlock)(UIImage *, NSIndexPath *, NSString *);

@property (nonatomic , copy)UIView *(^longPressCustomViewBlock)(UIImage *, NSIndexPath *);

@property (nonatomic , copy)void(^willDismissBlock)(void);

@property (nonatomic , copy)void(^didDismissBlock)(void);



@property (nonatomic , strong)NSArray *titles;

@property (nonatomic , strong)NSData *spareData;

// timer
// in ios 9 this property can be weak Replace strong
@property (nonatomic , strong)CADisplayLink *displayLink;
@property (nonatomic , assign) NSTimeInterval accumulator;
@property (nonatomic , strong)UIImage *currentGifImage;
@end
@implementation UXinPhotoBrowserManager
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[self alloc]init];
    });
    return mgr;
}
-(instancetype)init
{
    
}
@end
