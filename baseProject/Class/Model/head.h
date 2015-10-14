//
//  ViewController.h
//  tempPrj
//
//  Created by lihj on 13-4-9.
//  Copyright (c) 2013年 lihj. All rights reserved.
//

//#define kSERVE_URL      @"http://192.168.1.99:8081"
#define kSERVE_URL      @"http://www.91shipu.com:8081"

#define kSuccessCode    @"0"

#define kNavBarHeight   44
#define kAppMarket      @"appStore"
#define kAppName        [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]
#define kAppVersion     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBuildVersion     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define kDefaultHeadImage [UIImage imageNamed:@"默认头像.png"]
#define kDefaultLoadImage304_216 [UIImage imageNamed:@"资讯配图默认加载图片.png"]
#define kDefaultLoadImage [UIImage imageNamed:@"资讯配图默认加载图片.png"]

//判断字符串是否为空
#define strIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length]<1 ? YES : NO )

//设备屏幕大小
#define __MainScreenFrame  [[UIScreen mainScreen] bounds]
//设备屏幕宽
#define __MainScreen_Width  __MainScreenFrame.size.width
//设备屏幕高
#define __MainScreen_Height (__MainScreenFrame.size.height)

#define __AppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define kIOS7OrLater (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? YES : NO)

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#pragma mark - color functions
#define kRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define kRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
