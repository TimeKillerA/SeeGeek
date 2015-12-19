//
//  UIImageView+URL.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/19.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (URL)

@property (nonatomic, copy)NSString *stringTag;

- (void)showImageWithURL:(NSString *)url section:(NSString *)section defaultImage:(UIImage *)defaultImage;

@end
