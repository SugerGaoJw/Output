//
//  BaseTabBarController.h
//  MBaoBao
//
//  Created by ND on 13-6-8.
//  Copyright (c) 2013年 ND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController
{
    UIImageView *_backgroudImage;
    
    NSArray     *_selectionIndicators;  
    NSArray     *_itemImages;
    
    UIImageView *_badgeValueImage;
}

@property (nonatomic, retain) NSArray *selectionIndicators;

- (void)setTabBarItemsTitle:(NSArray *)titles;
- (void)setTabBarItemsImage:(NSArray *)images;

- (void)setTabBarBackgroundImage:(UIImage *)image;

- (void)setItemImages:(NSArray *)images;
- (void)setItemHighlightedImages:(NSArray *)highlightedImages;

- (void)removeSelectionIndicator;

- (void)showBadge;
- (void)hiddenBadge;

@end
