//
//  meetInfoLoader.m
//  collectionVer4_demo
//
//  Created by chensixin on 2025/8/27.
//

#import "meetInfoLoader.h"
#import "meetInfoModel.h"
#import "YYModel.h"


@implementation meetInfoLoader


// 读取这个 JSON 文件中的数据
+ (meetInfo *)loadMeetInfo{
    // 根据路径，读取
    NSString *Json_path = [[NSBundle mainBundle] pathForResource:@"meet" ofType:@"json"];
    NSData *Json_data = [NSData dataWithContentsOfFile:Json_path];
    // 
    NSDictionary *Json_dic = [NSJSONSerialization JSONObjectWithData:Json_data options:0 error:nil];
    meetInfo * mInfo = [meetInfo yy_modelWithJSON:Json_dic];
    // 可以在这个地方验证这个数据

    return mInfo;
    
    // 其他地方：meetInfo *mIfo = [meetInfoLoader loadMeetInfo]; 就读取到了
}

@end
