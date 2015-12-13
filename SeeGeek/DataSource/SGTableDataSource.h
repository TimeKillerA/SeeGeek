//
//  SGTableDataSource.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UITableViewCell *(^TableViewCellGenerator)(UITableView *tableView, NSIndexPath *indexPath);

@interface SGTableDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong)NSArray *sectionList;

- (instancetype)initWithTableViewCellGenerator:(TableViewCellGenerator)generator;

@end

@interface SGTableDataSourceSectionItem : NSObject

@property (nonatomic, assign)NSInteger itemCount;

- (instancetype)initWithItemCount:(NSInteger)itemCount;

@end