//
//  meetInfoModel.m
//  collectionVer4_demo
//
//  Created by chensixin on 2025/8/27.
//

#import "meetInfoModel.h"
#import "YYModel.h"

@implementation nameIcon

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"iconID" : @"id"
    };
}

@end


@implementation Tags

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
        @"tagsID" : @"id"
    };
}


// 数组类型的字段，还需要声明
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
        @"sub_tags" : [Tags class],
        @"nameIcon" : [nameIcon class]
    };
}

@end



@implementation meetInfo

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
        @"tags" : [Tags class]
    };
}


// 其他任意地方可以调用这个函数，验证数据是否读取完成完整
- (NSString *)description{
    return [self yy_modelDescription];
}

@end
