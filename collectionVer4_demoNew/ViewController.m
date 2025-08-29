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
// 外层的 collectionView
@property (nonatomic, strong) UICollectionView *outsetCollectionView;
// 添加下一步按钮
@property (nonatomic, strong) UIButton *nextStepButton;

@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 整个标题
    self.title = @"ver4_demo";
    
    [self setupData_mtInfo];
    
    [self setupLayout];
    
    [self setupCollectionView];
    
    [self setupNextStepButton];
    
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

// 设置下一步按钮
- (void)setupNextStepButton {
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    self.nextStepButton.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 100);
    
    self.nextStepButton.layer.cornerRadius = 25;
    self.nextStepButton.layer.masksToBounds = YES;
    
    [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.nextStepButton.backgroundColor = [UIColor lightGrayColor];
    
    self.nextStepButton.enabled = NO;
    [self.nextStepButton addTarget:self action:@selector(nextStepButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextStepButton];
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
    
    pCell.curPageIndex = indexPath.item; // 记录每个 pcell 所在的位置 0 1 2
    
    // 调用 pCell 中的函数，配置里层的数据
    [pCell setPageCellWithTagData:tags];
    
    pCell.delegate = self; // 这个 pcell 的外层代理是外面的这个 view
    
    // 返回
    return pCell;
}




#pragma mark - PageCellDelegate 实现的逻辑

// 实现页面跳转
// 1. 当前的页面是否需要跳转
// 2. 获取当前的分页的 tag 数据，因为要根据 max_cnt 字段判断是否切换页面
// 3. 切换页面的时候也判断一下
- (void)pageCellDidSelectTag_pageJump:(PageCell *)cell atIndex:(NSInteger)tagIndex {
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

/* 
 [self.outsetCollectionView scrollToItemAtIndexPath:nextIndexPath
                                   atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                           animated:YES];
 */



- (NSArray<NSIndexPath *> *)selectedIndexPathsForPageCell:(PageCell *)cell {
    return [cell.innerTagView indexPathsForSelectedItems];
}

/* // collectionview 的方法，返回当前这个view 中所选择的所有 item 的 nsindexpath 索引列表
 @property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForSelectedItems; // returns nil or an array of selected index paths
 */




// 获取最后一页选中标签的方法，打印用
// 1. 判断当前页面的索引值
// 2. 调用 pagecell 中的 collectionview 的方法，获取选择的 item 的索引列表
- (void)getLastPageSelectedTags:(PageCell *)cell {
    if (cell.curPageIndex == 2) {
        // 
        NSArray *selectedIndexPaths = [cell.innerTagView indexPathsForSelectedItems];
        NSLog(@"最后一页选中的标签数量: %lu", (unsigned long)selectedIndexPaths.count);
        
        // 更新下一步按钮状态
        [self updateNextStepButtonState:selectedIndexPaths.count > 0];
        
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            Tags *currentTag = [self.mtInfo.tags objectAtIndex:cell.curPageIndex];
            Tags *selectedSubTag = [currentTag.sub_tags objectAtIndex:indexPath.item];
            NSLog(@"选中的标签: %@ %@", selectedSubTag.emoji, selectedSubTag.name);
        }
    }
}



// 获取父标签的 max_cnt
// 父标签的 max_cnt 在外层的 collectionview 层的数据结构记录着
- (NSInteger)getParentTagMaxCountForPageCell:(PageCell *)cell {
    if (cell.curPageIndex < self.mtInfo.tags.count) {
        // 1. 获取当前 pagecell 的数据结构
        Tags *parentTag = [self.mtInfo.tags objectAtIndex:cell.curPageIndex];
        // 2. 返回这个字段
        return parentTag.max_cnt;
    }
    return 1; // 默认返回1
}



// 更新下一步按钮状态
- (void)updateNextStepButtonState:(BOOL)enabled {
    self.nextStepButton.enabled = enabled;
    if (enabled) {
        self.nextStepButton.backgroundColor = [UIColor redColor];
    } else {
        self.nextStepButton.backgroundColor = [UIColor lightGrayColor];
    }
}



// 下一步按钮点击事件，点击之后显示
- (void)nextStepButtonTapped {
    // 获取当前显示的PageCell
    NSInteger currentIndex = self.outsetCollectionView.contentOffset.x / self.outsetCollectionView.bounds.size.width;
    
    if (currentIndex < self.mtInfo.tags.count) {
        Tags *currentTag = [self.mtInfo.tags objectAtIndex:currentIndex];
        
        if (currentTag.max_cnt == 5) {
            // 显示选中的标签对话框
            [self showSelectedTagsDialog];
        }
    }
}



// 显示选中标签对话框
- (void)showSelectedTagsDialog {
    NSInteger currentIndex = self.outsetCollectionView.contentOffset.x / self.outsetCollectionView.bounds.size.width;
    
    if (currentIndex < self.mtInfo.tags.count) {
        Tags *currentTag = [self.mtInfo.tags objectAtIndex:currentIndex];
        NSMutableString *message = [NSMutableString stringWithString:@"选中的标签：\n"];
        
        // 获取当前PageCell
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        PageCell *currentCell = (PageCell *)[self.outsetCollectionView cellForItemAtIndexPath:indexPath];
        
        if (currentCell) {
            NSArray *selectedIndexPaths = [currentCell.innerTagView indexPathsForSelectedItems];
            for (NSIndexPath *tagIndexPath in selectedIndexPaths) {
                Tags *selectedSubTag = [currentTag.sub_tags objectAtIndex:tagIndexPath.item];
                [message appendFormat:@"%@ %@\n", selectedSubTag.emoji, selectedSubTag.name];
            }
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择结果" 
                                                                       message:message 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}





@end





