//
//  ZUMD5Crypt.h
//  baseProject
//
//  Created by ZhangSx on 15/10/19.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZUMD5Crypt : NSObject
+ (NSString *)HMACMD5WithString:(NSString *)toEncryptStr WithKey:(NSString *)keyStr;
@end
