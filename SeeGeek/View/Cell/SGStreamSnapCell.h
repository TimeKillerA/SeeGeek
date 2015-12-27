//
//  SGStreamSnapCell.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGStreamSummaryModel;

@interface SGStreamSnapCell : UICollectionViewCell

@property (nonatomic, strong)SGStreamSummaryModel *model;

+ (CGSize)cellSize;

@end
