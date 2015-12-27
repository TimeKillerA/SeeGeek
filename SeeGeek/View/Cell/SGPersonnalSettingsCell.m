//
//  SGPersonnalSettingsCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGPersonnalSettingsCell.h"
#import "SGTextField.h"
#import <Masonry.h>
#import "SGResource.h"
#import "SGPersonnalSettingsModel.h"
#import "UIImageView+URL.h"

@interface SGPersonnalSettingsCell ()

@property (nonatomic, strong)SGTextField *textField;
@property (nonatomic, strong)UIImageView *headImageView;

@end

@implementation SGPersonnalSettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addSubview:self.textField];
        [self addSubview:self.headImageView];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self).insets(UIEdgeInsetsMake(10, 0, 10, 20));
        make.width.mas_equalTo(80);
    }];
}

- (void)setModel:(SGPersonnalSettingsModel *)model {
    _model = model;
    if([model isKindOfClass:[SGPersonnalSettingsImageModel class]]) {
        SGPersonnalSettingsImageModel *imageModel = (SGPersonnalSettingsImageModel *)model;
        if(imageModel.image) {
            self.headImageView.image = imageModel.image;
        } else {
            [self.headImageView showImageWithURL:imageModel.imageUrl section:NSStringFromClass([self class]) defaultImage:nil];
        }
        return;
    }
    SGPersonnalSettingsTextModel *textModel = (SGPersonnalSettingsTextModel *)model;
    self.textField.title = textModel.title;
    self.textField.content = textModel.content;
}

#pragma mark - accessory
- (SGTextField *)textField {
    if(!_textField) {
        _textField = [[SGTextField alloc] init];
        _textField.titleFont = [UIFont fontForKey:SG_FONT_J];
        _textField.titleColor = [UIColor colorForFontKey:SG_FONT_J];
        _textField.contentFont = [UIFont fontForKey:SG_FONT_J];
        _textField.contentColor = [UIColor colorForFontKey:SG_FONT_J];
        _textField.contentTextAlignment = NSTextAlignmentRight;
        _textField.rightImage = [UIImage imageForKey:SG_IMAGE_FIELD_NEXT];
        _textField.insets = UIEdgeInsetsMake(0, 12, 0, 10);
    }
    return _textField;
}

- (UIImageView *)headImageView {
    if(!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

@end
