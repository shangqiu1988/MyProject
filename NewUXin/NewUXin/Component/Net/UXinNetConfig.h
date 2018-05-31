//
//  UXinNetConfig.h
//  NewUXin
//
//  Created by tanpeng on 17/8/8.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXinNetEngine.h"
NS_ASSUME_NONNULL_BEGIN
/**
 `UXinNetConfig` is used to assign values for XMCenter's properties through invoking `-setupConfig:` method.
 */

@interface UXinNetConfig : NSObject
///-----------------------------------------------
/// @name Properties to Assign Values for UXinNetCenter
///-----------------------------------------------

/**
 The general server address to assign for UXinNetCenter.
 */
@property (nonatomic, copy, nullable) NSString *generalServer;

/**
 The general parameters to assign for UXinNetCenter.
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *generalParameters;

/**
 The general headers to assign for UXinNetCenter.
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *generalHeaders;

/**
 The general user info to assign for UXinNetCenter.
 */
@property (nonatomic, strong, nullable) NSDictionary *generalUserInfo;

/**
 The dispatch callback queue to assign for UXinNetCenter.
 */
@property (nonatomic, strong, nullable) dispatch_queue_t callbackQueue;

/**
 The global requests engine to assign for UXinNetCenter.
 */
@property (nonatomic, strong, nullable) UXinNetEngine *engine;

/**
 The console log BOOL value to assign for UXinNetCenter.
 */
@property (nonatomic, assign) BOOL consoleLog;

@end
NS_ASSUME_NONNULL_END
