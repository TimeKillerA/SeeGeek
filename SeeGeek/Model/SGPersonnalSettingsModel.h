//
//  SGPersonnalSettingsModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGPersonnalSettingsModel : NSObject

@property (nonatomic, copy)NSString *title;

@end

@interface SGPersonnalSettingsTextModel : SGPersonnalSettingsModel

@property (nonatomic, copy)NSString *content;

@end

@interface SGPersonnalSettingsImageModel : SGPersonnalSettingsModel

@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, strong)UIImage *image;

@end