//
//  UXinBaseRequest.h
//  NewUXin
//
//  Created by tanpeng on 2018/2/22.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface UXinBaseRequest : YTKRequest
{
    NSDictionary *parms;
}
-(instancetype)initWithDefaultParms:(NSDictionary *)parms;
@end
