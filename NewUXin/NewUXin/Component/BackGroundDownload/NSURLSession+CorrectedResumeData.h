//
//  NSURLSession+CorrectedResumeData.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/26.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (CorrectedResumeData)
- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;
@end
