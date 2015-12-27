//
//  SGStreamSnapCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGStreamSnapCell.h"
#import "SGStreamSummaryModel.h"
#import "SGResource.h"
#import <Masonry.h>
#import "UIImageView+URL.h"

#define CELL_WIDTH (SCREEN_WIDTH/3)

@interface SGStreamSnapCell ()

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation SGStreamSnapCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.imageView];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setModel:(SGStreamSummaryModel *)model {
    _model = model;
    [self.imageView showImageWithURL:model.snapshotUrl section:NSStringFromClass([self class]) defaultImage:nil];
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

+ (CGSize)cellSize {
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH);
}

@end
