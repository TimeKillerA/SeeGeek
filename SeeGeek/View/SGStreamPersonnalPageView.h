//
//  SGStreamPersonnalPageView.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/2.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGStreamPersonPageViewDelegate <NSObject>

- (void)didFocusPerson;
- (void)didFocusLocation;

@end

@interface SGStreamPersonnalPageView : UIView

@property (nonatomic, weak)id<SGStreamPersonPageViewDelegate> delegate;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
