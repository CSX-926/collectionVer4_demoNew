//
//  PageCell.h
//  collectionVer4_demoNew
//
//  Created by chensixin on 2025/8/27.
//

//
//  这个 PageCell 作为最外面这一层的 collectionView 的 cell
//

#ifndef PageCell_h
#define PageCell_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "meetInfoModel.h"

@class PageCell;

// 定义一个协议，翻页的协议
@protocol PageCellDelegate <NSObject>

// 实现页面中 tagcell 选择之后跳转
- (void)pageCellDidSelectTag_pageJump:(PageCell *)cell atIndex:(NSInteger)tagIndex;

// 获取当前分页 pagecell 选择的 item 中的所有索引
- (NSArray<NSIndexPath *> *)selectedIndexPathsForPageCell:(PageCell *)cell;

// 获取最后一页选出来的所有 tags
- (void)getLastPageSelectedTags:(PageCell *)cell;

// 获取 pagecell 中父标签的 max_cnt
- (NSInteger)getParentTagMaxCountForPageCell:(PageCell *)cell;

@end






@interface PageCell : UICollectionViewCell

// 代理
@property (nonatomic, weak) id<PageCellDelegate> delegate;
// 记录当前页的索引值
@property (nonatomic, assign) NSInteger curPageIndex;
// cell 内部的 子 collectionView
@property (nonatomic, strong) UICollectionView *innerTagView;
// 添加选中时间记录，用于跟踪最早选择的标签，为了实现取消
@property (nonatomic, strong) NSMutableDictionary *selectionTimeMap;

// 配置外层的数据，vc 调用，要写在 .h 层
- (void)setPageCellWithTagData:(Tags *)tag;

@end

#endif /* PageCell_h */
