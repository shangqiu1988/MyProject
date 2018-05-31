//
//  UXinPhotoBrowserConst.h
//  NewUXin
//
//  Created by tanpeng on 2018/2/11.
//  Copyright © 2018年 Study. All rights reserved.
//

typedef NSMutableArray<NSURL *> PhotoUrlsMutableArray;
typedef NSMutableArray <NSValue *> PhotoFramesMutableArray;
typedef NSMutableArray<UIImage *> PhotoImagesMutableArray;
#ifdef DEBUG

#define PhotoBrowserLog(...) NSLog(__VA_ARGS__)

#else

#define PhotoBrowserLog(...)

#endif

#define  weak_self  __weak typeof(self) wself = self
#ifndef SCREEN_WIDTH

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#endif

#ifndef SCREEN_HEIGHT

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif

#define IS_IPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone

#define DISMISS_DISTENCE SCREEN_HEIGHT


#define BOTTOM_MARGIN_IPHONEX 34

#define STUATUS_BAR_HEIGHT_IPHONEX 44

#define IS_IPHONEX (SCREEN_HEIGHT == 812 && IS_IPHONE)

#define BOTTOM_MARGIN (IS_IPHONEX ? 34 : 0)

UIKIT_EXTERN NSString * const ImageViewWillDismissNot;
UIKIT_EXTERN NSString * const ImageViewDidDismissNot;
UIKIT_EXTERN NSString * const GifImageDownloadFinishedNot;

