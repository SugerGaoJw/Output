//
//  shareFun.h
//  tempPrj
//
//  Created by lihj on 13-4-8.
//  Copyright (c) 2013年 lihj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>


@interface shareFun : NSObject


/**
 *  显示警告框
 */
+ (void)showAlert:(NSString *)msg;

/**
 *  验证是否是EMAIL
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  验证是否是手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  颜色转图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  获取UILabel的高度
 */
+ (float)heightOfLabel:(UILabel *)label;

/**
 *  获取UILabel的宽度
 */
+ (float)widthOfLabel:(UILabel *)label;

/**
 *  截屏
 */
+ (UIImage *)imageFromView:(UIView *)view;

/**
 *  DataTOJsonString
 */
+ (NSString*)DataTOjsonString:(id)object;

/**
 *  获取count位的随机数
 */
+ (NSString *)strRandom:(NSInteger)count;

+ (NSString *)md5:(NSString *)str;

@end
