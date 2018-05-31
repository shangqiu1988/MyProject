//
//  UXinNetRequest.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConst.h"
#import "UXinNetUploadFormData.h"
NS_ASSUME_NONNULL_BEGIN

/**
 `UXinNetRequest` is the base class for all network requests invoked by UXinNetCenter.
 */

@interface UXinNetRequest : NSObject
/**
 Creates and returns a new `UXinNetRequest` object.
 */
+(instancetype)request;
/**
 The unique identifier for a UXinNetRequest object, the value is assigned by XMCenter when the request is sent.
 */
@property (nonatomic, copy, readonly) NSString *identifier;
/**
 The server address for request, eg. "http://example.com/v1/", if `nil` (default) and the `useGeneralServer` property is `YES` (default), the `generalServer` of UXinNetCenter is used.
 */
@property (nonatomic, copy, nullable) NSString *server;
/**
 The API interface path for request, eg. "foo/bar", `nil` by default.
 */
@property (nonatomic, copy, nullable) NSString *api;

/**
 The final URL of request, which is combined by `server` and `api` properties, eg. "http://example.com/v1/foo/bar", `nil` by default.
 NOTE: when you manually set the value for `url`, the `server` and `api` properties will be ignored.
 */
@property (nonatomic, copy, nullable) NSString *url;
/**
 The parameters for request, if `useGeneralParameters` property is `YES` (default), the `generalParameters` of UXinNetCenter will be appended to the `parameters`.
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *parameters;
/**
 The HTTP headers for request, if `useGeneralHeaders` property is `YES` (default), the `generalHeaders` of XMCenter will be appended to the `headers`.
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *headers;

@property (nonatomic, assign) BOOL useGeneralServer;        //!< Whether or not to use `generalServer` of XMCenter when request `server` is `nil`, `YES` by default.
@property (nonatomic, assign) BOOL useGeneralHeaders;       //!< Whether or not to append `generalHeaders` of XMCenter to request `headers`, `YES` by default.
@property (nonatomic, assign) BOOL useGeneralParameters;    //!< Whether or not to append `generalParameters` of XMCenter to request `parameters`, `YES` by default.

/**
 Type for request: Normal, Upload or Download, `RequestNormal` by default.
 */
@property(nonatomic,assign) RequestType requestType;
/**
 HTTP method for request, `kHTTPMethodPOST` by default, see `HTTPMethodType` enum for details.
 */
@property (nonatomic, assign) HTTPMethodType httpMethod;
/**
 Parameter serialization type for request, `RequestSerializerRAW` by default, see `RequestSerializerType` enum for details.
 */
@property (nonatomic, assign) RequestSerializerType requestSerializerType;

/**
 Response data serialization type for request, `ResponseSerializerJSON` by default, see `ResponseSerializerType` enum for details.
 */
@property (nonatomic, assign) ResponseSerializerType responseSerializerType;

/**
 Timeout interval for request, `60` seconds by default.
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 The retry count for current request when error occurred, `0` by default.
 */
@property (nonatomic, assign) NSUInteger retryCount;

/**
 User info for current request, which could be used to distinguish requests with same context, if `nil` (default), the `generalUserInfo` of XMCenter is used.
 */
@property (nonatomic, strong, nullable) NSDictionary *userInfo;
/**
 Success block for request, called when current request completed successful, the block will execute in `callbackQueue` of UXinNetCenter.
 */
@property (nonatomic, copy, readonly, nullable) SuccessBlock successBlock;

/**
 Failure block for request, called when error occurred, the block will execute in `callbackQueue` of UXinNetCenter.
 */
@property (nonatomic, copy, readonly, nullable) FailureBlock failureBlock;

/**
 Finished block for request, called when current request is finished, the block will execute in `callbackQueue` of UXinNetCenter.
 */
@property (nonatomic, copy, readonly, nullable) FinishedBlock finishedBlock;

/**
 Progress block for upload/download request, called when the upload/download progress is updated,
 NOTE: This block is called on the session queue, not the `callbackQueue` of XMCenter !!!
 */
@property (nonatomic, copy, readonly, nullable) ProgressBlock progressBlock;

/**
 Nil out all callback blocks when a request is finished to break the potential retain cycle.
 */
- (void)cleanCallbackBlocks;

/**
 Upload files form data for upload request, `nil` by default, see `UXinNetUploadFormData` class and `AFMultipartFormData` protocol for details.
 NOTE: This property is effective only when `requestType` is assigned to `kXMRequestUpload`.
 */
@property (nonatomic, strong, nullable) NSMutableArray<UXinNetUploadFormData *> *uploadFormDatas;

/**
 Local save path for downloaded file, `nil` by default.
 NOTE: This property is effective only when `requestType` is assigned to `RequestDownload`.
 */
@property (nonatomic, copy, nullable) NSString *downloadSavePath;

///----------------------------------------------------
/// @name Quickly Methods For Add Upload File Form Data
///----------------------------------------------------

- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData;
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData;
- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL;
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL;



@end
NS_ASSUME_NONNULL_END
