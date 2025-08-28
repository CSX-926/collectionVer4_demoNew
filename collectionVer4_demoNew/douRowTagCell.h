//
//  DouRowTagCell.h
//  collectionVer4_demoNew
//
//  Created by chensixin on 2025/8/27.
//

//
//  作为 PageCell 中的 collectionView 中的 两列标签 cell
//

#ifndef DouRowTagCell_h
#define DouRowTagCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "meetInfoModel.h"

@interface DouRowTagCell : UICollectionViewCell

- (void)setTagCellWithTagData:(Tags *)tag; 

@end

#endif /* DouRowTagCell_h */
