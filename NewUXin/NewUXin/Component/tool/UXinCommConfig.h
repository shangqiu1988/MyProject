//
//  UXinCommConfig.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

//常用变量
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define kMainScreenWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kMainScreenHeight  [UIScreen mainScreen].applicationFrame.size.height
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define MainWindow     [[UIApplication sharedApplication] keyWindow]

#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
// iPad
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//filesystem
#define PATH_AT_APPDIR(name)        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]
#define PATH_AT_DOCDIR(name)        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define PATH_AT_TMPDIR(name)        [NSTemporaryDirectory() stringByAppendingPathComponent:name]
#define PATH_AT_CACHEDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define PATH_AT_LIBDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define DeviceUUID  [[[UIDevice currentDevice]identifierForVendor]  UUIDString]
#define kCurrentTime        [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]]
#define fontSizeAdaptive(v) ([[UIScreen mainScreen] bounds].size.width>=375  ? (v+2) : (v))
