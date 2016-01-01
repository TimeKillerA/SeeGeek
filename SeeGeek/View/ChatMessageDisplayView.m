//
//  ChatMessageDisplayView.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/1.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "ChatMessageDisplayView.h"
#import <Masonry.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import "SGTableDataSource.h"
#import "SGResource.h"

static NSString *const CELL_IDENTIFER = @"MESSAGE_CELL_IDENTIFER";

#pragma mark - chat message item
@interface ChatMessageItem : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)UIColor *nameColor;
@property (nonatomic, strong)UIFont *nameFont;
@property (nonatomic, strong)UIColor *messageColor;
@property (nonatomic, strong)UIFont *messageFont;

+ (instancetype)messageItemWithName:(NSString *)name content:(NSString *)content;

@end

@implementation ChatMessageItem

+ (instancetype)messageItemWithName:(NSString *)name
                            content:(NSString *)content {
    ChatMessageItem *item = [[ChatMessageItem alloc] init];
    item.name = name;
    item.content = content;
    return item;
}

@end

#pragma mark - tableviewcell
@interface ChateTableViewCell : UITableViewCell

@property (nonatomic, strong)ChatMessageItem *item;
@property (nonatomic, strong)UILabel *label;

@end

@implementation ChateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self.contentView addSubview:self.label];
        [self updateConstraints];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setItem:(ChatMessageItem *)item {
    _item = item;
    NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@", item.name, item.content]];
    [messageString addAttribute:NSForegroundColorAttributeName value:item.nameColor range:NSMakeRange(0, item.name.length + 1)];
    [messageString addAttribute:NSFontAttributeName value:item.nameFont range:NSMakeRange(0, item.name.length + 1)];
    [messageString addAttribute:NSForegroundColorAttributeName value:item.messageColor range:NSMakeRange(item.name.length + 1, item.content.length)];
    [messageString addAttribute:NSFontAttributeName value:item.messageFont range:NSMakeRange(item.name.length + 1, item.content.length)];
    self.label.attributedText = messageString;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.contentView);
    }];
}

- (UILabel *)label {
    if(!_label) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 0;
    }
    return _label;
}

@end

#pragma mark - chat message displayview

@interface ChatMessageDisplayView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *messageArray;

@end

@implementation ChatMessageDisplayView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupDefaultData];
        [self addSubview:self.tableView];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - UI Setup
- (void)updateConstraints {
    [super updateConstraints];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setupDefaultData {
    self.nameFont = [UIFont fontForKey:SG_FONT_G];
    self.nameColor = [UIColor colorForFontKey:SG_FONT_G];
    self.messageFont = [UIFont fontForKey:SG_FONT_D];
    self.messageColor = [UIColor colorForFontKey:SG_FONT_D];
}

#pragma mark - public method
- (void)addMessage:(NSString *)message userName:(NSString *)userName {
    ChatMessageItem *item = [ChatMessageItem messageItemWithName:userName content:message];
    item.nameColor = self.nameColor;
    item.nameFont = self.nameFont;
    item.messageColor = self.messageColor;
    item.messageFont = self.messageFont;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messageArray count] inSection:0];
    [self.messageArray addObject:item];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFER];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configCell:(ChateTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ChatMessageItem *item = [self.messageArray objectAtIndex:indexPath.row];
    cell.item = item;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:CELL_IDENTIFER cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf configCell:cell atIndexPath:indexPath];
    }];
}

#pragma mark - accessory
- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    self.tableView.scrollEnabled = scrollEnable;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ChateTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFER];
    }
    return _tableView;
}

- (NSMutableArray *)messageArray {
    if(!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

@end
