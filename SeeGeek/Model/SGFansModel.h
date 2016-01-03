//
//  SGFansModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGFansModel : NSObject

@property (nonatomic, assign)SGIDInteger fansId;
@property (nonatomic, assign)BOOL focus;
@property (nonatomic, copy)NSString *headImageUrl;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *sign;

@end
