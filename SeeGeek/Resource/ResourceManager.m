//
//  ResourceManager.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "ResourceManager.h"

#define IMAGE_BUNDLE_NAME @"image_resource"
#define FONT_COLOR_BUNDLE_NAME @"font_color"

@interface ResourceManager ()

@property (nonatomic, strong)NSDictionary *fontDictionary;
@property (nonatomic, strong)NSDictionary *colorDictionary;
@property (nonatomic, strong)NSBundle *imageBundle;

@end

@implementation ResourceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ResourceManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ResourceManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.imageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:IMAGE_BUNDLE_NAME ofType:@"bundle"]];
    NSBundle *font_color_bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:FONT_COLOR_BUNDLE_NAME ofType:@"bundle"]];
    NSString *fontPath = [font_color_bundle pathForResource:@"font" ofType:@"plist"];
    NSString *colorPath = [font_color_bundle pathForResource:@"color" ofType:@"plist"];
    self.fontDictionary = [NSDictionary dictionaryWithContentsOfFile:fontPath];
    self.colorDictionary = [NSDictionary dictionaryWithContentsOfFile:colorPath];
}

- (NSDictionary *)fontValueForKey:(NSString *)key {
    if(key.length == 0) {
        return nil;
    }
    return [self.fontDictionary objectForKey:key];
}

- (NSString *)colorValueForKey:(NSString *)key {
    return [self.colorDictionary objectForKey:key];
}

- (NSString *)imagePathForKey:(NSString *)key {
    NSString *tempName = nil;
    if([key hasSuffix:@".png"] || [key hasSuffix:@".jpg"]) {
        tempName = [key substringToIndex:(key.length - 4)];
    } else {
        tempName = key;
    }

    NSString *result = nil;
    result = [self.imageBundle pathForResource:tempName ofType:@"png"];
    if(result == nil) {
        result = [self.imageBundle pathForResource:tempName ofType:@"jpg"];
    }
    return result;
}

@end
