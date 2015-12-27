//
//  SGPersonnalTextChangeViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGPersonnalTextChangeViewModelProtocol.h"
#import "SGViewControllerDispatcherDataSource.h"

typedef NS_ENUM(NSInteger, SGPersonnalTextType) {
    SGPersonnalTextTypeName,
    SGPersonnalTextTypeSign,
};

@interface SGPersonnalTextChangeViewModel : NSObject<SGPersonnalTextChangeViewModelProtocol, SGViewControllerDispatcherDataSource>

- (instancetype)initWithTextType:(SGPersonnalTextType)type;

@end
