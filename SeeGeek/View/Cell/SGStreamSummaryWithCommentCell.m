//
//  SGStreamSummaryWithCommentCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGStreamSummaryWithCommentCell.h"
#import "SGResource.h"
#import <Masonry.h>
#import "SGStreamSummaryWithCommentModel.h"
#import "UIImageView+URL.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "SGCommentCell.h"
#import <ReactiveCocoa.h>

#define IMAGE_WIDTH SCREEN_WIDTH
#define IMAGE_HEIGHT 225*SCREEN_SCALE

#define TITLE_MARGIN_TOP 8
#define TAG_MARGIN_TOP 4
#define IMAGE_MARGIN_TOP 5
#define BUTTON_HEIGHT 25

static NSString *const cellIdentifer = @"COMMENT_CELL_IDENTIFER";

@interface SGStreamSummaryWithCommentCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel     *locationLabel;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *tagLabel;
@property (nonatomic, strong) UIButton    *commentButton;
@property (nonatomic, strong) UIButton    *likeButton;
@property (nonatomic, strong) UIButton    *shareButton;
@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) UILabel     *timeLabel;

@end

@implementation SGStreamSummaryWithCommentCell

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self.contentView addSubview:self.snapImageView];
        [self.contentView addSubview:self.locationImageView];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.commentButton];
        [self.contentView addSubview:self.likeButton];
        [self.contentView addSubview:self.shareButton];
        [self.contentView addSubview:self.commentTableView];
        [self.contentView addSubview:self.timeLabel];
        [self updateConstraints];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (CGFloat)cellHeightWithModel:(SGStreamSummaryWithCommentModel *)model {
    CGFloat height = 0;
    
    return height;
}

#pragma mark - update UI
- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(TITLE_MARGIN_TOP);
        make.left.mas_equalTo(self.contentView).offset(12);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 0, 0, 15));
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(TAG_MARGIN_TOP);
        make.left.mas_equalTo(self.titleLabel);
    }];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(TAG_MARGIN_TOP);
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.locationImageView);
        make.left.mas_equalTo(self.locationImageView.mas_right).offset(3);
    }];
    [self.snapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.locationImageView.mas_bottom).offset(IMAGE_MARGIN_TOP);
        make.height.mas_equalTo(IMAGE_HEIGHT);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(1.0/3.0);
        make.height.mas_equalTo(BUTTON_HEIGHT);
        make.top.mas_equalTo(self.snapImageView.mas_bottom);
        make.left.mas_equalTo(self.contentView);
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.commentButton);
        make.height.mas_equalTo(self.commentButton);
        make.top.mas_equalTo(self.commentButton);
        make.left.mas_equalTo(self.commentButton.mas_right);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.commentButton);
        make.height.mas_equalTo(self.commentButton);
        make.top.mas_equalTo(self.commentButton);
        make.left.mas_equalTo(self.likeButton.mas_right);
    }];
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.likeButton.mas_bottom);
        make.bottom.mas_equalTo(self.contentView).priorityHigh();
    }];
}

#pragma mark - set data
- (void)setModel:(SGStreamSummaryWithCommentModel *)model {
    _model = model;
    [self fillData];
}

- (void)fillData {
    [self.snapImageView showImageWithURL:self.model.snapshotUrl section:NSStringFromClass([self class]) defaultImage:nil];
    self.locationLabel.text = self.model.location;
    self.titleLabel.text = self.model.streamTitle;
    self.tagLabel.text = self.model.streamTag;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", (int)self.model.likeNumber] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%d", (int)self.model.commentNumber] forState:UIControlStateNormal];
    [self fillCommentData];
}

- (void)fillCommentData {
    [self.commentTableView reloadData];
    [self.commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.commentTableView.contentSize.height);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.commentList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    [self configCell:cell indexPath:indexPath];
    return cell;
}

- (void)configCell:(SGCommentCell *)cell indexPath:(NSIndexPath *)indexPath {
    if(indexPath.row >= [self.model.commentList count]) {
        cell.model = nil;
        return;
    }
    SGCommentModel *comment = [self.model.commentList objectAtIndex:indexPath.row];
    cell.model = comment;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:cellIdentifer cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf configCell:cell indexPath:indexPath];
    }];
    return height;
}

#pragma mark - accessory
- (UIImageView *)snapImageView {
    if(!_snapImageView) {
        _snapImageView = [[UIImageView alloc] init];
        _snapImageView.backgroundColor = [UIColor redColor];
    }
    return _snapImageView;
}

- (UIImageView *)locationImageView {
    if(!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = [UIImage imageForKey:SG_IMAGE_LOCATION];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if(!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont fontForKey:SG_FONT_J];
        _locationLabel.textColor = [UIColor colorForFontKey:SG_FONT_J];
    }
    return _locationLabel;
}

- (UILabel *)tagLabel {
    if(!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont fontForKey:SG_FONT_O];
        _tagLabel.textColor = [UIColor colorForFontKey:SG_FONT_O];
    }
    return _tagLabel;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontForKey:SG_FONT_O];
        _titleLabel.textColor = [UIColor colorForFontKey:SG_FONT_O];
    }
    return _titleLabel;
}

- (UIButton *)commentButton {
    if(!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        [_commentButton setImage:[UIImage imageForKey:SG_IMAGE_COMMENT] forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor colorForFontKey:SG_FONT_J] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = [UIFont fontForKey:SG_FONT_J];
    }
    return _commentButton;
}

- (UIButton *)likeButton {
    if(!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        [_likeButton setImage:[UIImage imageForKey:SG_IMAGE_LIKE] forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor colorForFontKey:SG_FONT_J] forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont fontForKey:SG_FONT_J];
    }
    return _likeButton;
}

- (UIButton *)shareButton {
    if(!_shareButton) {
        _shareButton = [[UIButton alloc] init];
    }
    return _shareButton;
}

- (UITableView *)commentTableView {
    if(!_commentTableView) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        [_commentTableView registerClass:[SGCommentCell class] forCellReuseIdentifier:cellIdentifer];
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTableView.backgroundColor = [UIColor redColor];
        _commentTableView.scrollEnabled = NO;
        _commentTableView.scrollsToTop = NO;
    }
    return _commentTableView;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorForFontKey:SG_FONT_O];
        _timeLabel.font = [UIFont fontForKey:SG_FONT_O];
    }
    return _timeLabel;
}

@end
