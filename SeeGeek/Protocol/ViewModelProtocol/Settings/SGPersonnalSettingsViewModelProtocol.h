//
//  SGPersonnalSettingsViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGPersonnalSettingsModel;

@protocol SGPersonnalSettingsViewModelProtocol <NSObject>

- (NSArray *)personnalSettingsItemList;
- (void)dispatchToPersonnalSettingsItem:(SGPersonnalSettingsModel *)item;

@end
