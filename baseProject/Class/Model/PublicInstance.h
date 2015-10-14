//
//  AudioPlayerInstance.h
//  XMU1.0
//
//  Created by lihj on 14-5-6.
//  Copyright (c) 2014年 DongXM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicInstance : NSObject  {
}

+ (PublicInstance *)instance;

/**
 *  是否登录
 */
@property (nonatomic, assign) BOOL isLogin;

/**
 *  用户登录名
 */
@property (nonatomic, copy) NSString *userLoginName;

/**
 *  用户密码
 */
@property (nonatomic, copy) NSString *userPwd;

/**
 *  菜单分类
 */
@property (nonatomic, copy) NSArray *orderArr;

@end
