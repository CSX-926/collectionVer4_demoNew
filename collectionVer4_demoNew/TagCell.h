//
//  TagCell.h
//  collectionVer4_demoNew
//
//  Created by chensixin on 2025/8/27.
//

//
//  作为 pageCell 中的 collectionView 中的 标签 cell
//


#ifndef TagCell_h
#define TagCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "meetInfoModel.h"

@interface TagCell : UICollectionViewCell

- (void)setTagCellWithTagData:(Tags *)tag; 

@end


#endif /* TagCell_h */
