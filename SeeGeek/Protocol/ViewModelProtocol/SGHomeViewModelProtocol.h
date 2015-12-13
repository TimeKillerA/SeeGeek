//
//  SGHomeViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGHomeViewModelProtocol <NSObject>

/**
 *  返回对应Tab上的viewmodel
 *
 *  @param index
 *
 *  @return 
 */
- (id)viewModelAtIndex:(NSInteger)index;

@end
