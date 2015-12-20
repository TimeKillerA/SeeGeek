//
//  SGCollectionViewDataSource.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/20.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGCollectionViewDataSource.h"

@interface SGCollectionViewDataSource ()

@property (nonatomic, copy)CollectionViewCellGenerator generator;

@end

@implementation SGCollectionViewDataSource

- (instancetype)initWithGenerator:(CollectionViewCellGenerator)generator
{
    self = [super init];
    if(self)
    {
        self.generator = generator;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([self.sectionList count] == 0 || section > [self.sectionList count])
    {
        return 0;
    }
    SGCollectionViewDataSourceSectionItem *item = [self.sectionList objectAtIndex:section];
    return item.itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.generator(collectionView, indexPath);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sectionList count];
}

@end

@interface SGCollectionViewWithSupplementaryDataSource ()

@property (nonatomic, copy)CollectionViewReusableViewGenerator reusableGenerator;

@end

@implementation SGCollectionViewWithSupplementaryDataSource

- (instancetype)initWithGenerator:(CollectionViewCellGenerator)generator reusableViewGenerator:(CollectionViewReusableViewGenerator)reusableGenerator
{
    self = [self initWithGenerator:generator];
    if(self)
    {
        self.reusableGenerator = reusableGenerator;
    }
    return self;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(!self.reusableGenerator)
    {
        return nil;
    }
    return self.reusableGenerator(collectionView, kind, indexPath);
}

@end

@implementation SGCollectionViewDataSourceSectionItem

- (instancetype)initWithItemCount:(NSInteger)itemCount
{
    self = [super init];
    if(self)
    {
        self.itemCount = itemCount;
    }
    return self;
}

@end
