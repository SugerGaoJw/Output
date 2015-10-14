//
//  UIImage+Scale.h
//  XMU
//
//  Created by 林小果 on 13-7-19.
//  Copyright (c) 2013年 林小果. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;
- (UIImage *)fixOrientation:(UIImage *)aImage;

@end