//
//  meetInfoModel.h
//  collectionVer4_demo
//
//  Created by chensixin on 2025/8/27.
//

// 
//  把这个 json 文件的所有结构都定义在这个文件
//  这个文件也只写 属性的映射规则，从文件中加载 json 就使用另一个逻辑类
//  

#ifndef meetInfoModel_h
#define meetInfoModel_h

#import <Foundation/Foundation.h>

// NameIcon
@interface nameIcon : NSObject

@property (nonatomic, assign) NSInteger iconID;
@property (nonatomic, assign) NSInteger w;
@property (nonatomic, assign) NSInteger h;
@property (nonatomic, copy) NSString *fmt;
@property (nonatomic, copy) NSString *url;

@end


// Tags
@interface Tags : NSObject

@property (nonatomic, assign) NSInteger tagsID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *emoji;
@property (nonatomic, assign) NSInteger max_cnt;
@property (nonatomic, strong) nameIcon *name_icon;
@property (nonatomic, strong) NSArray<Tags *> *sub_tags;
@property (nonatomic, assign) NSInteger show_type;
@property (nonatomic, copy) NSString *icon_day_normal;
@property (nonatomic, copy) NSString *icon_day_selected;
@property (nonatomic, copy) NSString *icon_night_normal;
@property (nonatomic, copy) NSString *icon_night_selected;
@property (nonatomic, copy) NSString *tips;

@end




// meetInfo
@interface meetInfo : NSObject

@property (nonatomic, assign) NSInteger minCnt;
@property (nonatomic, assign) NSInteger maxCnt;
@property (nonatomic, assign) BOOL isSkip;
@property (nonatomic, strong) NSArray<Tags *> *tags; // 这个数组的数量决定一共有多少页
@property (nonatomic, copy) NSString *exampleMale;
@property (nonatomic, copy) NSString *exampleFemale;

@end


#endif /* meetInfoModel_h */
