//
//  SGCommentCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGCommentCell.h"
#import "SGCommentModel.h"
#import "SGResource.h"
#import <Masonry.h>
#import "SGUserSummaryModel.h"

@interface SGCommentCell ()

@property (nonatomic, strong)UILabel *commentLabel;

@end

@implementation SGCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self.contentView addSubview:self.commentLabel];
        [self setConstraints];
    }
    return self;
}

- (void)setConstraints {
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 0, 15, 0));
        make.width.mas_equalTo(self.contentView).priorityHigh();
    }];
}

- (void)setModel:(SGCommentModel *)model {
    _model = model;
    if(model) {
        SGUserSummaryModel *fromUser = model.fromUser;
        SGUserSummaryModel *toUser = model.toUser;
        NSString *fromUserName = fromUser.userName;
        NSString *toUserName = toUser.userName;
        NSString *fullContent = nil;
        if(toUserName.length == 0) {
            fullContent = [NSString stringWithFormat:@"%@ %@", fromUserName, model.content];
        } else {
            fullContent = [NSString stringWithFormat:@"%@ 回复 %@ %@", fromUserName, toUserName, model.content];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullContent];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorForFontKey:SG_FONT_G] range:NSMakeRange(0, fromUserName.length)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontForKey:SG_FONT_G] range:NSMakeRange(0, fromUserName.length)];
        NSInteger contentOffset = fromUserName.length + 1;
        if(toUserName.length > 0) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorForFontKey:SG_FONT_G] range:NSMakeRange(fromUserName.length + 4, toUserName.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontForKey:SG_FONT_G] range:NSMakeRange(fromUserName.length + 4, toUserName.length)];
            contentOffset += toUserName.length + 4;
        }
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorForFontKey:SG_FONT_K] range:NSMakeRange(contentOffset, fullContent.length - contentOffset)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontForKey:SG_FONT_K] range:NSMakeRange(contentOffset, fullContent.length - contentOffset)];
        self.commentLabel.attributedText = attributedString;
        self.commentLabel.text = nil;
    } else {
        self.commentLabel.text = [NSString stringForKey:SG_TEXT_EXPAND_ALL_COMMENT];
        self.commentLabel.font = [UIFont fontForKey:SG_FONT_G];
        self.commentLabel.textColor = [UIColor colorForFontKey:SG_FONT_G];
        self.commentLabel.attributedText = nil;
    }
    [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
    }];
}

- (UILabel *)commentLabel {
    if(!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.numberOfLines = 0;
        _commentLabel.backgroundColor = [UIColor redColor];
        _commentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH;
    }
    return _commentLabel;
}

@end
