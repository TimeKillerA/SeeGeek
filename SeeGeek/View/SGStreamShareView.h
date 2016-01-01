//
//  SGStreamShareView.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/1.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGStreamShareView;
@class SGStreamSummaryModel;

@protocol SGStreamShareViewDelegate <NSObject>

- (void)streamShareView:(SGStreamShareView *)shareView didShareWithShareType:(SGThirdPartType)type;

@end

@interface SGStreamShareView : UIView

@property (nonatomic, weak)id<SGStreamShareViewDelegate> delegate;
@property (nonatomic, strong)SGStreamSummaryModel *summaryModel;

@end
