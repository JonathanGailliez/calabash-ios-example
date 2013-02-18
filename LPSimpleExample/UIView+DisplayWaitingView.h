//
//  UIView+DisplayWaitingView.h
//  Keecoach
//
//  Created by Damien Leroy on 27/08/12.
//
//

#import <UIKit/UIKit.h>

@interface UIView (DisplayWaitingView)

- (void)displayWaitingMaskWithText:(NSString *)message;
- (void)displayWaitingMask;
- (void)hideWaitingMask;

@end
