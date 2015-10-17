//
//  AudioPlayerInstance.m
//  XMU1.0
//
//  Created by lihj on 14-5-6.
//  Copyright (c) 2014年 DongXM. All rights reserved.
//

#import "PublicInstance.h"

@implementation PublicInstance

+ (PublicInstance *)instance
{
    static PublicInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
        _userPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
        _userLoginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLoginName"];

    }
    return self;
}

- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    [sud setBool:isLogin forKey:@"isLogin"];
    
    if (_SusBtn) {
        _SusBtn.hidden = NO;
    }
}

- (void)setUserLoginName:(NSString *)userLoginName {
    _userLoginName = userLoginName;
    [[NSUserDefaults standardUserDefaults] setObject:userLoginName forKey:@"userLoginName"];
}

- (void)setUserPwd:(NSString *)userPwd {
    _userPwd = userPwd;
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    [sud setObject:userPwd forKey:@"userPwd"];
}

//- (void)setOrderArr:(NSArray *)odrerArr {
//    _odrerArr = odrerArr;
//    [[NSUserDefaults standardUserDefaults] setObject:odrerArr forKey:@"odrerArr"];
//}


@end
