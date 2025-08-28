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
    
    // 每个 PageCell 的宽度=屏幕宽度，高度=664
    self.layout.itemSize = CGSizeMake(self.view.bounds.size.width, 664);
    
    // 设置每个 pagecell 的位置
    CGFloat topDis = self.view.bounds.size.height - 664;
    // top, left, bottom, right, 居下显示
    self.layout.sectionInset = UIEdgeInsetsMake(topDis, 0, 0, 0);
    
    // 我靠啊，误区误区 呜呜呜呜
    self.layout.minimumLineSpacing = 0; // 行间距
    self.layout.minimumInteritemSpacing = 0;
    
}



// 创建 collectionView
- (void)setupCollectionView{
    // 初始化这个 collectionView
    self.outsetCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    
    self.outsetCollectionView.backgroundColor = [UIColor systemRedColor];
//    self.outsetCollectionView.layer.cornerRadius = 16;
//    self.outsetCollectionView.clipsToBounds = YES;
    
    
    // 设置数据源
    self.outsetCollectionView.dataSource = self;
    self.outsetCollectionView.delegate = self;
    
    // 对于这个 collectionView 有一个自定义的 pageCell，需要注册
    [self.outsetCollectionView registerClass:[PageCell class] forCellWithReuseIdentifier:kPageCellIdentifier];

    // 启用分页效果
    self.outsetCollectionView.pagingEnabled = YES;
    
    // 滚动行为
    self.outsetCollectionView.scrollEnabled = NO; // 禁用手动滚动，使用程序控制
    
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
    
    pCell.curPageIndex = indexPath.item;
    
    // 调用 pCell 中的函数，配置数据
    [pCell setPageCellWithTagData:tags];
    
    pCell.delegate = self; // 这个 pcell 的外层代理是外面的这个 view
    
    // 返回
    return pCell;
}




#pragma mark - PageCellDelegate

- (void)pageCellDidSelectTag:(PageCell *)cell atIndex:(NSInteger)tagIndex {
    // 根据max_cnt处理跳转逻辑
    if (cell.curPageIndex < self.mtInfo.tags.count) {
        Tags *currentTag = [self.mtInfo.tags objectAtIndex:cell.curPageIndex];
        
        if (currentTag.max_cnt == 1) {
            // 单选页面，选择后自动跳转到下一页
            if (cell.curPageIndex < self.mtInfo.tags.count - 1) {
                
                NSInteger nextPageIndex = cell.curPageIndex + 1;
                [self.outsetCollectionView setContentOffset:CGPointMake(self.outsetCollectionView.bounds.size.width * nextPageIndex, 0) animated:YES];
                NSLog(@"单选页面 - 跳转到下一页: %ld", (long)nextPageIndex);
            }
        } else {
            // 多选页面，不自动跳转
        }
    }
}



- (NSArray<NSIndexPath *> *)selectedIndexPathsForPageCell:(PageCell *)cell {
    return [cell.innerTagView indexPathsForSelectedItems];
}




// 添加获取最后一页选中标签的方法
- (void)getLastPageSelectedTags:(PageCell *)cell {
    if (cell.curPageIndex == 2) {
        NSArray *selectedIndexPaths = [cell.innerTagView indexPathsForSelectedItems];
        NSLog(@"最后一页选中的标签数量: %lu", (unsigned long)selectedIndexPaths.count);
        
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            Tags *currentTag = [self.mtInfo.tags objectAtIndex:cell.curPageIndex];
            Tags *selectedSubTag = [currentTag.sub_tags objectAtIndex:indexPath.item];
            NSLog(@"选中的标签: %@ %@", selectedSubTag.emoji, selectedSubTag.name);
        }
    }
}



// 获取父标签的max_cnt
- (NSInteger)getParentTagMaxCountForPageCell:(PageCell *)cell {
    if (cell.curPageIndex < self.mtInfo.tags.count) {
        
        Tags *parentTag = [self.mtInfo.tags objectAtIndex:cell.curPageIndex];
        return parentTag.max_cnt;
    }
    return 1; // 默认返回1
}





@end





