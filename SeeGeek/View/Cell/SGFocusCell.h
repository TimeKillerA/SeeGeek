//
//  SGFocusCell.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGFocusCellItem;
@class SGFocusCell;

@protocol SGFocusCellDelegate <NSObject>

- (void)didClickFocusButtonInFocusCell:(SGFocusCell *)focusCell;
- (void)didClickMoreActionButtonInFocusCell:(SGFocusCell *)focusCell;

@end

@interface SGFocusCell : UITableViewCell

@property (nonatomic, weak)id<SGFocusCellDelegate> delegate;
@property (nonatomic, strong)SGFocusCellItem *focusItem;

@end

@interface SGFocusCellItem : NSObject

@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)BOOL focus;
@property (nonatomic, assign)BOOL showMoreAction;

@end