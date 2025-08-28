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

- (void)pageCellDidSelectTag:(PageCell *)cell atIndex:(NSInteger)tagIndex;

- (NSArray<NSIndexPath *> *)selectedIndexPathsForPageCell:(PageCell *)cell;

- (void)getLastPageSelectedTags:(PageCell *)cell;

- (NSInteger)getParentTagMaxCountForPageCell:(PageCell *)cell;

@end






@interface PageCell : UICollectionViewCell

@property (nonatomic, weak) id<PageCellDelegate> delegate;
// 
@property (nonatomic, assign) NSInteger curPageIndex;
// cell 内部的 子 collectionView
@property (nonatomic, strong) UICollectionView *innerTagView;
// 修复：添加选中时间记录，用于跟踪最早选择的标签
@property (nonatomic, strong) NSMutableDictionary *selectionTimeMap;



- (void)setPageCellWithTagData:(Tags *)tag;

@end

#endif /* PageCell_h */
