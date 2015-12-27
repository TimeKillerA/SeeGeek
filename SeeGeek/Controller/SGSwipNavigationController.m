//
//  SGSwipNavigationController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGSwipNavigationController.h"
#import <CEPanAnimationController.h>
#import <CEHorizontalSwipeInteractionController.h>

@interface SGSwipNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong)CEPanAnimationController *animationController;
@property (nonatomic, strong)CEHorizontalSwipeInteractionController *interactionController;

@end

@implementation SGSwipNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if(self)
    {
        self.delegate = self;
        self.animationController = [[CEPanAnimationController alloc] init];
        self.interactionController = [[CEHorizontalSwipeInteractionController alloc] init];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    [self.interactionController wireToViewController:toVC forOperation:CEInteractionOperationPop];
    self.interactionController.popOnRightToLeft = NO;
    self.animationController.reverse = operation == UINavigationControllerOperationPop;
    return self.animationController;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if(animationController == nil)
    {
        return nil;
    }
    return self.interactionController.interactionInProgress ? self.interactionController : nil;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self willChangeValueForKey:@"viewControllers"];
    [self didChangeValueForKey:@"viewControllers"];
}

@end
