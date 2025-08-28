//
//  PageCell.m
//  collectionVer4_demoNew
//
//  Created by chensixin on 2025/8/27.
//

//
//  这个 PageCell 作为最外面这一层的 collectionView 的 cell
//

#import "PageCell.h"
#import "TagCell.h"
#import "DouRowTagCell.h"

@interface PageCell()<UICollectionViewDataSource, UICollectionViewDelegate>

// 子 collectionView 的布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *innerTagViewLayout;



// 这个 pageCell 的所有 tags 数据（子 cell)，使用数组存
@property (nonatomic, strong) NSArray<Tags *> *sub_tags;

@property (nonatomic, strong) UILabel *titleLabel;

@end




@implementation PageCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    
    return self;
}


// 设置当前的 pageCell
- (void) setupUI{
    // 1. 设置当前这个 pageCell 的一些小细节
    // 颜色
    self.backgroundColor = [UIColor systemBackgroundColor];
    // 圆角
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    
    // 
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.titleLabel];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:24],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor]
    ]];
    
    
    
    // 2. 设置在这个 pageCell 上的子控件的相关
    [self setupInnerTagViewLayout];
    [self setupInnerTagCollectionView];
    
}




// 设置 layout；创建；设置 item 大小和 item 的行间距
- (void)setupInnerTagViewLayout{
    self.innerTagViewLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 默认设置 item 大小（单列显示）
    self.innerTagViewLayout.itemSize = CGSizeMake(343, 56);
    // 行间距
    self.innerTagViewLayout.minimumLineSpacing = 12;
    // 列间距
    self.innerTagViewLayout.minimumInteritemSpacing = 12;
}




// 设置 内部的collectionView
- (void)setupInnerTagCollectionView{
    self.innerTagView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.innerTagViewLayout];
    
    self.innerTagView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 设置数据源
    self.innerTagView.dataSource = self;
    self.innerTagView.delegate = self;
    
    // 绑定自定义的Cell类型
    [self.innerTagView registerClass:[TagCell class] forCellWithReuseIdentifier:@"tagCellIdentofier"];
    [self.innerTagView registerClass:[DouRowTagCell class] forCellWithReuseIdentifier:@"douRowTagCellIdentofier"];
    
    //
    self.innerTagView.allowsSelection = YES;
    
    self.innerTagView.scrollEnabled = YES;
    
    // 注意：这里不能直接设置多选，因为curPageIndex可能还没有设置
    // 多选设置将在setPageCellWithTagData方法中进行
    
    [self.contentView addSubview:self.innerTagView];
    
    self.innerTagView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.innerTagView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10],
        [self.innerTagView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.innerTagView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.innerTagView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
    
}




// 外层传过来的 tags 是 每个分页的所有子tags
// 通过在外层调用，就设置了当前分页的数据
- (void)setPageCellWithTagData:(Tags *)tag{
    
    self.sub_tags = tag.sub_tags;
    
    self.titleLabel.text = tag.name;
    
    
    // 根据max_cnt设置布局和选择模式
    BOOL max_cnt_flag = (tag.max_cnt > 1); // 获取
    self.innerTagView.allowsMultipleSelection = max_cnt_flag;
    
    // 根据max_cnt设置布局
    [self updateLayoutForMaxCount:tag.max_cnt];
    
    // 初始化选中时间记录
    if (max_cnt_flag) {
        if (!self.selectionTimeMap) {
            self.selectionTimeMap = [NSMutableDictionary dictionary];
        }
    }
    
    
    // 实现刷新，否则内部不显示
    [self.innerTagView reloadData];
}





#pragma mark - 数据源方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sub_tags.count;
}



/*
 // 获取父标签的max_cnt
 - (NSInteger)getParentTagMaxCount {
     if ([self.delegate respondsToSelector:@selector(getParentTagMaxCountForPageCell:)]) {
         return [self.delegate getParentTagMaxCountForPageCell:self];
     }
     return 1; // 默认返回1
 }
 */


// 设置每一个 tagCell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 当前这个 pagecell 中存了 当前这个分页的所有 子tags
    // 按照位置取出一个
    Tags *tags = self.sub_tags[indexPath.item];
    
    // 根据max_cnt选择不同的Cell类型
    UICollectionViewCell *cell;
    
    // 获取父标签的max_cnt（通过代理获取）
//    NSInteger maxCount = [self getParentTagMaxCount];
    NSInteger maxCount = [self.delegate getParentTagMaxCountForPageCell:self];
    
    if (maxCount == 1) {
        // 单列显示，使用TagCell
        TagCell *tCell = [self.innerTagView dequeueReusableCellWithReuseIdentifier:@"tagCellIdentofier" forIndexPath:indexPath];
        [tCell setTagCellWithTagData:tags];
        cell = tCell;
    } else if (maxCount == 5) {
        // 两列显示，使用DouRowTagCell
        DouRowTagCell *douCell = [self.innerTagView dequeueReusableCellWithReuseIdentifier:@"douRowTagCellIdentofier" forIndexPath:indexPath];
        [douCell setTagCellWithTagData:tags];
        cell = douCell;
    } else {
        // 默认使用TagCell
        TagCell *tCell = [self.innerTagView dequeueReusableCellWithReuseIdentifier:@"tagCellIdentofier" forIndexPath:indexPath];
        [tCell setTagCellWithTagData:tags];
        cell = tCell;
    }
    
    return cell;
}





#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 根据max_cnt处理选择逻辑
    NSInteger maxCount = [self getParentTagMaxCount];
    
    if (maxCount > 1) {
        // 多选逻辑，最多选择maxCount个
        NSArray *selectedItems = [collectionView indexPathsForSelectedItems];
        
        // 如果当前item已经被选中，允许取消选中
        if ([selectedItems containsObject:indexPath]) {
            return YES;
        }
        
        // 检查是否超过最大选择数量
        if (selectedItems.count >= maxCount) {
            // 超过限制，自动取消时间上最早选择的那个
            NSIndexPath *earliestSelectedPath = [self findEarliestSelectedIndexPath:selectedItems];
            if (earliestSelectedPath) {
                [collectionView deselectItemAtIndexPath:earliestSelectedPath animated:YES];
                // 从时间记录中移除
                [self.selectionTimeMap removeObjectForKey:@(earliestSelectedPath.item).stringValue];
            }
        }
        
        return YES;
    } else {
        // 单选逻辑，选择新项目时取消之前的选择
        NSArray *selectedItems = [collectionView indexPathsForSelectedItems];
        for (NSIndexPath *selectedPath in selectedItems) {
            [collectionView deselectItemAtIndexPath:selectedPath animated:YES];
        }
    }
    
    return YES;
}



// 点击 tagcell 的时候会调用这个
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TagCell的setSelected方法会自动处理视觉更新
    
    // 记录选择时间（仅多选页面）
    NSInteger maxCount = [self getParentTagMaxCount];
    if (maxCount > 1) {
        [self.selectionTimeMap setObject:[NSDate date] forKey:@(indexPath.item).stringValue];
    }
    
    if ([self.delegate respondsToSelector:@selector(pageCellDidSelectTag:atIndex:)]) {
        [self.delegate pageCellDidSelectTag:self atIndex:indexPath.item];
    }
    
    // 如果是多选页面，获取选中的标签信息
    if (maxCount > 1 && [self.delegate respondsToSelector:@selector(getLastPageSelectedTags:)]) {
        [self.delegate getLastPageSelectedTags:self];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 如果是多选页面，获取选中的标签信息
    NSInteger maxCount = [self getParentTagMaxCount];
    if (maxCount > 1 && [self.delegate respondsToSelector:@selector(getLastPageSelectedTags:)]) {
        [self.delegate getLastPageSelectedTags:self];
    }
    
    // 从时间记录中移除取消选中的标签
    if (maxCount > 1) {
        [self.selectionTimeMap removeObjectForKey:@(indexPath.item).stringValue];
    }
}

// 添加查找最早选择标签的方法
- (NSIndexPath *)findEarliestSelectedIndexPath:(NSArray *)selectedItems {
    if (!self.selectionTimeMap || selectedItems.count == 0) {
        return selectedItems.firstObject; // 如果没有时间记录，返回第一个
    }
    
    NSIndexPath *earliestPath = nil;
    NSDate *earliestTime = [NSDate distantFuture]; // 设置为最远的时间
    
    for (NSIndexPath *indexPath in selectedItems) {
        NSDate *selectionTime = [self.selectionTimeMap objectForKey:@(indexPath.item).stringValue];
        if (selectionTime && [selectionTime compare:earliestTime] == NSOrderedAscending) {
            earliestTime = selectionTime;
            earliestPath = indexPath;
        }
    }
    
    return earliestPath ?: selectedItems.firstObject;
}



// 获取父标签的max_cnt
- (NSInteger)getParentTagMaxCount {
    if ([self.delegate respondsToSelector:@selector(getParentTagMaxCountForPageCell:)]) {
        return [self.delegate getParentTagMaxCountForPageCell:self];
    }
    return 1; // 默认返回1
}






// 根据max_cnt更新布局
- (void)updateLayoutForMaxCount:(NSInteger)maxCount {
    if (maxCount == 1) {
        // 单列显示
        self.innerTagViewLayout.itemSize = CGSizeMake(343, 56);
        self.innerTagViewLayout.minimumLineSpacing = 12;
        self.innerTagViewLayout.minimumInteritemSpacing = 0;
    } else if (maxCount == 5) {
        // 两列显示
        self.innerTagViewLayout.itemSize = CGSizeMake(166, 56);
        self.innerTagViewLayout.minimumLineSpacing = 12;
        self.innerTagViewLayout.minimumInteritemSpacing = 11;
    }
    
    // 重新设置布局
    [self.innerTagView setCollectionViewLayout:self.innerTagViewLayout animated:NO];
}

@end
