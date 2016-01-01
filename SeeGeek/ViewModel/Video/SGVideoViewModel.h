//
//  SGVideoViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/1.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGVideoViewModelProtocol.h"
#import "SGViewControllerDispatcherDataSource.h"

@class SGStreamSummaryModel;

@interface SGVideoViewModel : NSObject<SGVideoViewModelProtocol, SGViewControllerDispatcherDataSource>

- (instancetype)initWithStreamSummaryModel:(SGStreamSummaryModel *)streamSummary;

@end
