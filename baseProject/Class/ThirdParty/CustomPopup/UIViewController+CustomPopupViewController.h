//
//  UIViewController+CustomPopupViewController.h
//  MJModalViewController
//
//  Created by lihj on 12-12-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CustomPopupViewAnimationSlideBottomTop = 1,
    CustomPopupViewAnimationSlideRightLeft,
    CustomPopupViewAnimationSlideBottomBottom,
    CustomPopupViewAnimationFade
} CustomPopupViewAnimation;

@interface UIViewController (CustomPopupViewController)

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(CustomPopupViewAnimation)animationType;
- (void)dismissPopupViewControllerWithanimationType:(CustomPopupViewAnimation)animationType;
- (void)presentPopupView:(UIView*)popupView animationType:(CustomPopupViewAnimation)animationType;
- (void)slideViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(CustomPopupViewAnimation)animationType;
- (void)slideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(CustomPopupViewAnimation)animationType;
- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView;
- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView;

@end