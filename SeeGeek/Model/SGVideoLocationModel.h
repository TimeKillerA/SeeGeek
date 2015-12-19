//
//  SGVideoLocationModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/19.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGVideoLocationModel : NSObject

@property (nonatomic, assign)double longitude;
@property (nonatomic, assign)double lantitude;
@property (nonatomic, assign)SGStreamType streamType;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, copy)NSString *location;

@end
