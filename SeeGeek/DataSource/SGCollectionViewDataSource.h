//
//  SGCollectionViewDataSource.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/20.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UICollectionViewCell *(^CollectionViewCellGenerator)(UICollectionView *collectionView, NSIndexPath *indexPath);

typedef UICollectionReusableView *(^CollectionViewReusableViewGenerator)(UICollectionView *collectionView, NSString *kind, NSIndexPath *indexPath);

@interface SGCollectionViewDataSource : NSObject

@property (nonatomic, strong)NSArray *sectionList;

- (instancetype)initWithGenerator:(CollectionViewCellGenerator)generator;

@end

@interface SGCollectionViewWithSupplementaryDataSource : SGCollectionViewDataSource

- (instancetype)initWithGenerator:(CollectionViewCellGenerator)generator reusableViewGenerator:(CollectionViewReusableViewGenerator)reusableGenerator;

@end

@interface SGCollectionViewDataSourceSectionItem : NSObject

@property (nonatomic, assign)NSInteger itemCount;

- (instancetype)initWithItemCount:(NSInteger)itemCount;

@end