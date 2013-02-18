//
//  UIViewr+DisplayWaitingView.m
//  Keecoach
//
//  Created by Damien Leroy on 27/08/12.
//
//

#import "UIView+DisplayWaitingView.h"
#import <objc/runtime.h>

static void const * kViewMaskViewKey = @"kViewControllerMaskView";
static void const * kMaskViewIsFadingKey = @"kViewControllerMaskViewFading";
static const int kFadeOutDuration = 0.2;

@implementation UIView (DisplayWaitingView)

- (void)displayWaitingMask
{
    UIView *maskView = objc_getAssociatedObject(self, kViewMaskViewKey);
    if (!maskView)
    {
        self.userInteractionEnabled = NO;
        UIActivityIndicatorView *maskView = [[UIActivityIndicatorView alloc] initWithFrame:self.frame];
        maskView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        maskView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        maskView.opaque = NO;
        maskView.alpha = 0;
        maskView.backgroundColor = [UIColor blackColor];
        [maskView startAnimating];
        [self addSubview:maskView];
        objc_setAssociatedObject(self, kViewMaskViewKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0.7;
        }];
    }

}

- (void)displayWaitingMaskWithText:(NSString *)message
{
    UIView *maskView = objc_getAssociatedObject(self, kViewMaskViewKey);

    if (!maskView)
    {
        self.userInteractionEnabled = NO;
        UILabel *maskView = [[UILabel alloc] initWithFrame:self.frame];
        maskView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        maskView.opaque = NO;
        maskView.alpha = 0;
        maskView.backgroundColor = [UIColor blackColor];
        maskView.text = message;
        maskView.font = [UIFont boldSystemFontOfSize:21];
        maskView.textColor = [UIColor whiteColor];
        maskView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:maskView];
        objc_setAssociatedObject(self, kViewMaskViewKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [UIView animateWithDuration:1 animations:^{
            maskView.alpha = 0.7;
        }];
    }
    else if (objc_getAssociatedObject(self, kMaskViewIsFadingKey))
    {
        [self performSelector:@selector(displayWaitingMaskWithText:) withObject:message afterDelay:kFadeOutDuration];
    }

}

- (void)hideWaitingMask
{

    UIView *maskView = objc_getAssociatedObject(self, kViewMaskViewKey);
    objc_setAssociatedObject(self, kMaskViewIsFadingKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (maskView && maskView.alpha > 0)
    {
        self.userInteractionEnabled = YES;
        [UIView animateWithDuration:kFadeOutDuration animations:^{
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            objc_setAssociatedObject(self, kViewMaskViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, kMaskViewIsFadingKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        }];
    }
}

@end
