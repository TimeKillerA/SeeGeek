//
//  UICollectionView+CellHeight.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "UICollectionView+CellHeight.h"

static NSMutableDictionary *cellDictionary = nil;

@implementation UICollectionView (CellHeight)

- (CGFloat)cellHeightWithClass:(Class)cls configraion:(UICollectionCellConfigration)configration {
    if(cls == NULL) {
        return 0;
    }
    if(!cellDictionary) {
        cellDictionary = [NSMutableDictionary dictionary];
    }
    id object = [cellDictionary objectForKey:NSStringFromClass(cls)];
    if(!object) {
        object = [[cls alloc] init];
        [cellDictionary setValue:object forKey:NSStringFromClass(cls)];
    }
    if(![object isKindOfClass:[UICollectionViewCell class]]) {
        return 0;
    }
    UICollectionViewCell *cell = (UICollectionViewCell *)object;
    [cell prepareForReuse];
    if(configration) {
        configration(cell);
    }
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

@end
