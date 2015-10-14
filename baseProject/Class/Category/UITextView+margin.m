//
//  UITextView+margin.m
//  XMU1.0
//
//  Created by lihj on 14-3-31.
//  Copyright (c) 2014年 DongXM. All rights reserved.
//

#import "UITextView+margin.h"

@implementation UITextView (margin)


- (CGSize)getContentSize {
    CGSize newSize = self.contentSize; //UITextView的实际高度
    if (kIOS7OrLater) {//7.0以上我们需要自己计算高度
        //        float fPadding = 16.0; // 8.0px x 2
        //
        CGSize constraint = CGSizeMake(self.contentSize.width, CGFLOAT_MAX);
        
        CGSize size = [self.text sizeWithFont:self.font
                            constrainedToSize:constraint
                                lineBreakMode:NSLineBreakByWordWrapping];
        newSize.height = size.height + 15;
        
        //        else {
        //            CGRect textFrame=[[self layoutManager] usedRectForTextContainer:[self textContainer]];
        //            newSize.height = textFrame.size.height + 18.0;
        //        }
    }
    return newSize;
}


@end
