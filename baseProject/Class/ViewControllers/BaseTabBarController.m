//
//  BaseTabBarController.m
//  MBaoBao
//
//  Created by ND on 13-6-8.
//  Copyright (c) 2013年 ND. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

- (void)removeSelectionIndicator:(UITabBarController *)tabBarController;

@end

@implementation BaseTabBarController

@synthesize selectionIndicators = _selectionIndicators;

- (id)init {
    self = [super init];
    if (self) {
        [self addObserver:self
               forKeyPath:@"selectedViewController"
                  options:NSKeyValueObservingOptionInitial
                  context:nil];
        [self addObserver:self
               forKeyPath:@"selectedIndex"
                  options:NSKeyValueObservingOptionInitial
                  context:nil];
        
        
        if (_backgroudImage == nil) {
            _backgroudImage = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
            _backgroudImage.contentMode = UIViewContentModeCenter;
            [self.tabBar addSubview:_backgroudImage];
        }
        
        if (_badgeValueImage == nil) {
            _badgeValueImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_warning.png"]];
            _badgeValueImage.hidden = YES;
            [self.tabBar addSubview:_badgeValueImage];
        }
        
//        if (_selectionIndicator == nil) {
//            _selectionIndicator = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
//            _selectionIndicator.contentMode = UIViewContentModeCenter;
//            _selectionIndicator.hidden = YES;
//            [self.tabBar addSubview:_selectionIndicator];
//        }
        
        [[UITabBarItem appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          kRGBCOLOR(222, 33, 41), NSForegroundColorAttributeName,
          [UIFont systemFontOfSize:0.0], NSFontAttributeName,
          nil] forState:UIControlStateSelected];
        
        
        [[UITabBarItem appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          kRGBCOLOR(104, 104, 104), NSForegroundColorAttributeName,
          [UIFont systemFontOfSize:0.0], NSFontAttributeName,
          nil] forState:UIControlStateNormal];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selectedViewController"];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self) {
        NSInteger index = self.selectedIndex;
        [self removeSelectionIndicator:self];
        
        for (int i = 0; i < _itemImages.count; ++i) {
            UIImageView *currentItemImage = [_itemImages objectAtIndex:i];
            if (i == index) {
                currentItemImage.highlighted = YES;
            } else {
                currentItemImage.highlighted = NO;
            }
        }
    }
}

#pragma mark - Private Method

- (void)removeSelectionIndicator
{
    [self removeSelectionIndicator:self];
}

- (void)removeSelectionIndicator:(UITabBarController *)tabBarController {
    for (UIView *subview in tabBarController.tabBar.subviews) {
        if ([NSStringFromClass([subview class])
             isEqualToString:@"UITabBarButton"]) {
            for (UIView *currentView in subview.subviews) {
                if ([NSStringFromClass([currentView class])
                     isEqualToString:@"UITabBarSelectionIndicatorView"]) {
                    [currentView removeFromSuperview];
                    break;
                }
            }
        }
    }
}

#pragma mark - OverRide Super Class
- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
    NSMutableArray *itemImages = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < viewControllers.count; ++i) {
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tabBar.frame.size.width / viewControllers.count * i, 0, self.tabBar.frame.size.width / viewControllers.count, 49)];
        itemImageView.contentMode = UIViewContentModeCenter;
        itemImageView.image = nil;
        [itemImages addObject:itemImageView];
    }
    
    if (_itemImages)
    {
        for (UIImageView *imageView in _itemImages) {
            [imageView removeFromSuperview];
        }
        _itemImages = nil;
    }
    
    _itemImages = [[NSArray alloc] initWithArray:itemImages];
    for (UIImageView *imageView in _itemImages) {
        if ([_itemImages indexOfObject:imageView] == 0) {
            imageView.highlighted = YES;
        }
        
        [self.tabBar addSubview:imageView];
    }
}

#pragma mark - Setter for Items Title

- (void)setTabBarItemsTitle:(NSArray *)titles
{
    for (int i = 0; i < self.tabBar.items.count && i < titles.count; ++i)
    {
        UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
        tabBarItem.title = [titles objectAtIndex:i];
    }
}

#pragma mark - Setter for Items Image

- (void)setTabBarItemsImage:(NSArray *)images 
{
    for (int i = 0; i < self.tabBar.items.count && i < images.count; ++i) {
        UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
        tabBarItem.image = [images objectAtIndex:i];
    }
}

- (void)setTabBarBackgroundImage:(UIImage *)image 
{
    _backgroudImage.image = image;
}

- (void)setItemImages:(NSArray *)images 
{
    for (int i = 0; i < _itemImages.count && i < images.count; ++i) {
        UIImageView *imageView = [_itemImages objectAtIndex:i];
        imageView.image = [images objectAtIndex:i];
    }
}

- (void)setItemHighlightedImages:(NSArray *)highlightedImages 
{
    for (int i = 0; i < _itemImages.count && i < highlightedImages.count; ++i) {
        UIImageView *imageView = [_itemImages objectAtIndex:i];
        imageView.highlightedImage = [highlightedImages objectAtIndex:i];
    }
}

- (void)showBadge
{
    NSInteger imageCount = _itemImages.count;
    CGFloat cellWidth = self.tabBar.frame.size.width / imageCount;
    CGFloat xOffest = self.tabBar.frame.size.width - cellWidth/2.0 + 8.0f;
    _badgeValueImage.frame = CGRectMake( xOffest, 8.0f, 8.0f, 8.0f);
    _badgeValueImage.hidden = NO;
}

- (void)hiddenBadge
{
    _badgeValueImage.hidden = YES;
}


@end
