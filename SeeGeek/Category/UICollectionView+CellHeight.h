//
//  UICollectionView+CellHeight.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UICollectionCellConfigration)(id cell);

@interface UICollectionView (CellHeight)

- (CGFloat)cellHeightWithClass:(Class)cls configraion:(UICollectionCellConfigration)configration;

@end
