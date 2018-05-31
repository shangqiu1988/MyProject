//
//  NetConst.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//
#ifndef UXinNetConst_h
#define UXinNetConst_h

#define Net_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })
#define NetLock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define NetUnlock() dispatch_semaphore_signal(self->_lock)

NS_ASSUME_NONNULL_BEGIN
@class UXinNetRequest,UXinNetBatchRequest,UXinNetChainRequest;
/**
 Types enum for Request.
 */
typedef NS_ENUM(NSInteger,RequestType){
    RequestNormal   =0 ,      //!< Normal HTTP request type, such as GET, POST, ...
    RequestUpload   =1 ,       //!< Upload request type
    RequestDownload =2         //!< Download request type
};
/**
 HTTP methods enum for Request.
 */
typedef NS_ENUM(NSInteger, HTTPMethodType) {
    HTTPMethodGET    = 0,    //!< GET
    HTTPMethodPOST   = 1,    //!< POST
    HTTPMethodHEAD   = 2,    //!< HEAD
    HTTPMethodDELETE = 3,    //!< DELETE
    HTTPMethodPUT    = 4,    //!< PUT
    HTTPMethodPATCH  = 5,    //!< PATCH
};
/**
 Resquest parameter serialization type enum for XMRequest, see `AFURLRequestSerialization.h` for details.
 */
typedef NS_ENUM(NSInteger, RequestSerializerType) {
    RequestSerializerRAW     = 0,    //!< Encodes parameters to a query string and put it into HTTP body, setting the `Content-Type` of the encoded request to default value `application/x-www-form-urlencoded`.
    RequestSerializerJSON    = 1,    //!< Encodes parameters as JSON using `NSJSONSerialization`, setting the `Content-Type` of the encoded request to `application/json`.
    RequestSerializerPlist   = 2,    //!< Encodes parameters as Property List using `NSPropertyListSerialization`, setting the `Content-Type` of the encoded request to `application/x-plist`.
};

/**
 Response data serialization type enum for XMRequest, see `AFURLResponseSerialization.h` for details.
 */
typedef NS_ENUM(NSInteger, ResponseSerializerType) {
    ResponseSerializerRAW    = 0,    //!< Validates the response status code and content type, and returns the default response data.
    ResponseSerializerJSON   = 1,    //!< Validates and decodes JSON responses using `NSJSONSerialization`, and returns a NSDictionary/NSArray/... JSON object.
    ResponseSerializerPlist  = 2,    //!< Validates and decodes Property List responses using `NSPropertyListSerialization`, and returns a property list object.
    ResponseSerializerXML    = 3,    //!< Validates and decodes XML responses as an `NSXMLParser` objects.
};
///------------------------------
/// @name XMRequest Config Blocks
///------------------------------

typedef void (^RequestConfigBlock)(UXinNetRequest *request);
typedef void (^BatchRequestConfigBlock)(UXinNetBatchRequest *batchRequest);
typedef void (^ChainRequestConfigBlock)(UXinNetChainRequest *chainRequest);

///--------------------------------
/// @name XMRequest Callback Blocks
///--------------------------------

typedef void (^ProgressBlock)(NSProgress *progress);
typedef void (^SuccessBlock)(id _Nullable responseObject);
typedef void (^FailureBlock)(NSError * _Nullable error);
typedef void (^FinishedBlock)(id _Nullable responseObject, NSError * _Nullable error);
typedef void (^CancelBlock)(id _Nullable request); // The `request` might be a XMRequest/XMBatchRequest/XMChainRequest object.

///-------------------------------------------------
/// @name Callback Blocks for Batch or Chain Request
///-------------------------------------------------

typedef void (^BCSuccessBlock)(NSArray *responseObjects);
typedef void (^BCFailureBlock)(NSArray *errors);
typedef void (^BCFinishedBlock)(NSArray * _Nullable responseObjects, NSArray * _Nullable errors);
typedef void (^BCNextBlock)(UXinNetRequest *request, id _Nullable responseObject, BOOL *isSent);

///------------------------------
/// @name XMCenter Process Blocks
///------------------------------

/**
 The custom request pre-process block for all XMRequests invoked by XMCenter.
 
 @param request The current XMRequest object.
 */
typedef void (^CenterRequestProcessBlock)(UXinNetRequest *request);

/**
 The custom response process block for all XMRequests invoked by XMCenter.
 
 @param request The current XMRequest object.
 @param responseObject The response data return from server.
 @param error The error that occurred while the response data don't conforms to your own business logic.
 */
typedef void (^CenterResponseProcessBlock)(UXinNetRequest *request, id _Nullable responseObject, NSError * _Nullable __autoreleasing *error);

NS_ASSUME_NONNULL_END

#endif
