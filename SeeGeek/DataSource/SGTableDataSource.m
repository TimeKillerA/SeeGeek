//
//  SGTableDataSource.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGTableDataSource.h"

@interface SGTableDataSource ()

@property (nonatomic, copy)TableViewCellGenerator generator;

@end

@implementation SGTableDataSource

- (instancetype)initWithTableViewCellGenerator:(TableViewCellGenerator)generator
{
    self = [super init];
    if(self)
    {
        self.generator = generator;
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section > [self.sectionList count] || [self.sectionList count] == 0)
    {
        return 0;
    }
    SGTableDataSourceSectionItem *item = [self.sectionList objectAtIndex:section];
    return item.itemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.generator(tableView, indexPath);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionList count];
}

@end

@implementation SGTableDataSourceSectionItem

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
