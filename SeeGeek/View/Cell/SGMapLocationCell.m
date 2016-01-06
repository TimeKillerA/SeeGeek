
//
//  SGMapLocationCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/6.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGMapLocationCell.h"
#import "SGResource.h"
#import <Masonry.h>

@interface SGMapLocationCell ()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIImageView *locationImageView;
@property (nonatomic, strong)UILabel *indexLabel;

@end

@implementation SGMapLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.locationImageView];
        [self addSubview:self.indexLabel];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.locationImageView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationImageView.mas_right).offset(10);
        make.top.mas_equalTo(self).offset(10);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
}

- (void)updateWithTitle:(NSString *)title content:(NSString *)content index:(NSInteger)index {
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.indexLabel.text = [NSString stringWithFormat:@"%d", (int)index];
}

+ (CGFloat)cellHeight {
    return 50;
}

#pragma mark - accessory
- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontForKey:SG_FONT_O];
        _titleLabel.textColor = [UIColor colorForFontKey:SG_FONT_O];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont fontForKey:SG_FONT_K];
        _contentLabel.textColor = [UIColor colorForFontKey:SG_FONT_K];
    }
    return _contentLabel;
}

- (UIImageView *)locationImageView {
    if(!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageForKey:SG_IMAGE_LOCATION_RED]];
    }
    return _locationImageView;
}

- (UILabel *)indexLabel {
    if(!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:13];
        _indexLabel.textColor = [UIColor whiteColor];
    }
    return _indexLabel;
}

@end
