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
- (void)pageCellDidSelectTag:(PageCell *)cell;
- (void)pageCell:(PageCell *)cell didSelectTagAtIndex:(NSInteger)tagIndex;

@end

// ==================================================

@interface PageCell : UICollectionViewCell

@property (nonatomic, weak) id<PageCellDelegate> delegate;

// 
@property (nonatomic, assign) NSInteger curPageIndex;

- (void)setPageCellWithTagData:(Tags *)tag;

@end

#endif /* PageCell_h */
