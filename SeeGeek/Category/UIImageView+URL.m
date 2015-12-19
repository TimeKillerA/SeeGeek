
//
//  UIImageView+URL.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/19.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "UIImageView+URL.h"
#import "UIImage+Resize.h"
#import "SGRuntimeHeader.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (URL)

OBJC_ASSOCIATED(stringTag, setStringTag, OBJC_ASSOCIATION_COPY_NONATOMIC)

- (void)showImageWithURL:(NSString *)url section:(NSString *)section defaultImage:(UIImage *)defaultImage
{
    if(url.length == 0)
    {
        self.image = defaultImage;
        return;
    }
    self.stringTag = url;
    NSString *tempKey = [NSString stringWithFormat:@"%@%@", url, section];
    UIImage *diskImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:tempKey];
    if(diskImage)
    {
        self.image = diskImage;
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image)
            {
                weakSelf.image = defaultImage;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    UIImage *resultImage = [image resizedImageWithoutScaleToSize:weakSelf.frame.size];
                    if([weakSelf.stringTag isEqualToString:imageURL.absoluteString])
                    {
                        NSString *key = [NSString stringWithFormat:@"%@%@", imageURL.absoluteString, section];
                        [[SDImageCache sharedImageCache] storeImage:resultImage forKey:key toDisk:YES];
                        [[SDImageCache sharedImageCache] removeImageForKey:imageURL.absoluteString fromDisk:NO];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.image = resultImage;
                        });
                    }
                });
            }
        }];
    }
}

@end
