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

@interface PageCell()<UICollectionViewDataSource, UICollectionViewDelegate>

// 子 collectionView 的布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *innerTagViewLayout;

// cell 内部的 子 collectionView
@property (nonatomic, strong) UICollectionView *innerTagView;

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
    
    // 设置 item 也就是 cell 的宽高
    self.innerTagViewLayout.itemSize = CGSizeMake(343, 56);
    // 行间距
    self.innerTagViewLayout.minimumLineSpacing = 12;
}



// 设置 内部的collectionView
- (void)setupInnerTagCollectionView{
    self.innerTagView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.innerTagViewLayout];
    
    self.innerTagView.backgroundColor = [UIColor systemBackgroundColor];
    
    // 设置数据源
    self.innerTagView.dataSource = self;
    self.innerTagView.delegate = self;
    
    // 绑定自定义的
    [self.innerTagView registerClass:[TagCell class] forCellWithReuseIdentifier:@"tagCellIdentofier"];
    
    //
    self.innerTagView.allowsSelection = YES;
    
    self.innerTagView.scrollEnabled = YES;
    
    // 允许多选，但是后面得改
    // ❗️
    self.innerTagView.allowsMultipleSelection = YES;
    
    
    
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




// 设置每一个 tagCell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 从复用队列里面取出一个重用
    TagCell *tCell = [self.innerTagView dequeueReusableCellWithReuseIdentifier:@"tagCellIdentofier" forIndexPath:indexPath];
    
    // 当前这个 pagecell 中存了 当前这个分页的所有 子tags
    // 按照位置取出一个
    Tags *tags = self.sub_tags[indexPath.item];
    
    // 调用 tcell 的配置数据函数
    [tCell setTagCellWithTagData:tags]; 
    
    
    return tCell;
}





#pragma mark - UICollectionViewDelegate

// 点击 tagcell 的时候会调用这个
// 判断
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"点击了内部的 TagCell at index %ld", indexPath.item);
    
    if ([self.delegate respondsToSelector:@selector(pageCellDidSelectTag:)]) {
        [self.delegate pageCellDidSelectTag:self];
    }

}


@end
