//
//  shareFun.m
//  tempPrj
//
//  Created by lihj on 13-4-8.
//  Copyright (c) 2013年 lihj. All rights reserved.
//

#import "shareFun.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation shareFun

+ (void)showAlert:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
    [alert show];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark check
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /***
     手机号码
     *China Mobile
     移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     *China Unicom
     联通：130,131,132,152,155,156,185,186
     *China Telecom
     电信：133,1349,153,180,189
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     //NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
     ***/
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES) ||
       ([regextestcm evaluateWithObject:mobileNum] == YES) ||
       ([regextestct evaluateWithObject:mobileNum] == YES) ||
       ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else {
        return NO;
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (float)heightOfLabel:(UILabel *)label {
    
    CGSize size = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize labelsize = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:label.lineBreakMode];
    return ceil(labelsize.height);
}

+ (float)widthOfLabel:(UILabel *)label {
    CGSize size = CGSizeMake(CGFLOAT_MAX, label.frame.size.height);
    CGSize labelsize = [label.text sizeWithFont:label.font constrainedToSize:size];
    return labelsize.width;
}

+ (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContext(view.frame.size); //currentView 当前的view
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    return viewImage;
}

+ (NSString*)DataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)strRandom:(NSInteger)count {
    NSString *strRandom = @"";
    
    for(int i=0; i<count; i++) {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    return strRandom;
}

//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
