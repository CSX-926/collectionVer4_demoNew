//
//  meetInfoLoader.h
//  collectionVer4_demo
//
//  Created by chensixin on 2025/8/27.
//

// 作为一个读取加载 json 信息的工具类

#import <Foundation/Foundation.h>
#import "meetInfoModel.h"

@class meetInfo;

@interface meetInfoLoader : NSObject

+ (meetInfo *)loadMeetInfo;

@end
