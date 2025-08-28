//
//  ViewController.m
//  collectionVer4_demoNew
//
//  Created by chensixin on 2025/8/27.
//

#import "ViewController.h"
#import "meetInfoLoader.h"
#import "PageCell.h"

static NSString *const kPageCellIdentifier = @"pc_collectionViewCell";


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PageCellDelegate>

// 用来加载数据，存储整个逻辑的数据体
@property (nonatomic, strong) meetInfo* mtInfo;
// 外层的 colllectionView 布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
// 最外层的 collectionView
@property (nonatomic, strong) UICollectionView *outsetCollectionView;


@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 整个标题
    self.title = @"collectionVer4_demo";
    
    [self setupData_mtInfo];
    
    [self setupLayout];
    
    [self setupCollectionView];
    
}




// 使用加载器加载数据
- (void)setupData_mtInfo{
    self.mtInfo = [meetInfoLoader loadMeetInfo];
}



- (void)setupLayout{
    // 初始化对象
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 这个collectionView 是 水平滚动
    
    // 整个外层的宽高，这个 collectionview 的 item 的宽高
    self.layout.itemSize = CGSizeMake(self.view.bounds.size.width, 664);
    
    // 设置每个 pagecell 的位置
    CGFloat topInset = (self.view.bounds.size.height - 664) / 2.0;
    self.layout.sectionInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    
    self.layout.minimumLineSpacing = 10; // 行间距
    self.layout.minimumInteritemSpacing = 0;
    
}



// 创建 collectionView
- (void)setupCollectionView{
    // 初始化这个 collectionView
    self.outsetCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    
    self.outsetCollectionView.backgroundColor = [UIColor systemBlueColor];
    
    // 设置数据源
    self.outsetCollectionView.dataSource = self;
    self.outsetCollectionView.delegate = self;
    
    // 对于这个 collectionView 有一个自定义的 pageCell，需要注册
    [self.outsetCollectionView registerClass:[PageCell class] forCellWithReuseIdentifier:kPageCellIdentifier];
    

    
    // 滚动显示指示
    self.outsetCollectionView.showsVerticalScrollIndicator = NO;
    self.outsetCollectionView.showsHorizontalScrollIndicator = NO;

    // 设置 collectionView 的分页效果
    self.outsetCollectionView.pagingEnabled = YES;
    
    // 滚动行为
    self.outsetCollectionView.scrollEnabled = YES;
    
    // 添加到视图层级
    [self.view addSubview:self.outsetCollectionView];
    
    // 设置自动布局
    self.outsetCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.outsetCollectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.outsetCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
 
        [self.outsetCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.outsetCollectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    
    NSLog(@"contentOffset = %@", NSStringFromCGPoint(self.outsetCollectionView.contentOffset));
    
}




#pragma mark -- 数据源函数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}



// 这个section 有多少个 item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mtInfo.tags.count;
}



// 设置每一个 pageCell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 重用队列中获取 cell
    PageCell *pCell = [self.outsetCollectionView dequeueReusableCellWithReuseIdentifier:kPageCellIdentifier forIndexPath:indexPath];
    
    Tags *tags = self.mtInfo.tags[indexPath.item]; // 取出这三个大 tags 中的一个
    
    pCell.curPageIndex = indexPath.item; // ❗️
    
    // 调用 pCell 中的函数，配置数据
    [pCell setPageCellWithTagData:tags];
    
    pCell.delegate = self; // 这个 pcell 的外层代理是外面的这个 view
    
    // 返回
    return pCell;
}




#pragma mark - PageCellDelegate
- (void)pageCellDidSelectTag:(PageCell *)cell {
    NSInteger nextPageIndex = cell.curPageIndex + 1;
    
    NSLog(@"cell.curPageIndex = %ld", cell.curPageIndex);
    NSLog(@"self.mtInfo.tags.count = %ld", self.mtInfo.tags.count);
    
    if(nextPageIndex < self.mtInfo.tags.count){
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextPageIndex inSection:0];
        
        [self.outsetCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}





@end




