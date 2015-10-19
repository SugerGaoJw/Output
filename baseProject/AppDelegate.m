//
//  AppDelegate.m
//  baseProject
//
//  Created by Li on 14/12/9.
//  Copyright (c) 2014年 Li. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BaseTabBarController.h"
#import "InteractivePopNavigationController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "ZBarReaderView.h"
#import "MobClick.h"
#import "RCDraggableButton.h"

@interface AppDelegate () {
    NSString *_url;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [MobClick startWithAppkey:@"54f90dbdfd98c5f6d30007de"];
    [MobClick checkUpdate];
    [ZBarReaderView class];
//    [self setUpSusBtn];
    [self getLoginState];
    [self customizeInterface];
    [self setupShareSDK];
    [self setupBaiduMap];
    [self setupViewControllers];
    [self checkUpdate];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];

//    [PublicInstance instance].isLogin = YES;
    
    return YES;
}

#pragma mark - Methods
- (void)setUpSusBtn
{
    RCDraggableButton *sBtn = [[RCDraggableButton alloc] initInKeyWindowWithFrame:CGRectMake(0, 100, 47, 47)];
    [sBtn setBackgroundImage:[UIImage imageNamed:@"04_4-评价_星星点亮"] forState:UIControlStateNormal];
    [sBtn setTapActionWithBlock:^{
        NSLog(@"进入购物车");
    }];
    sBtn.hidden = YES;
    [[PublicInstance instance] setSusBtn:sBtn];
}
- (void)setupViewControllers {
    UIViewController *firstViewController = [[FirstViewController alloc] init];
    UINavigationController *firstNavigationController = [[InteractivePopNavigationController alloc]
                                                         initWithRootViewController:firstViewController];
    firstNavigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    UIViewController *secondViewController = [[SecondViewController alloc] init];
    UINavigationController *secondNavigationController = [[InteractivePopNavigationController alloc]
                                                          initWithRootViewController:secondViewController];
    secondNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIViewController *thirdViewController = [[ThirdViewController alloc] init];
    UINavigationController *thirdNavigationController = [[InteractivePopNavigationController alloc]
                                                         initWithRootViewController:thirdViewController];
    thirdNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIViewController *fourthViewController = [[FourthViewController alloc] initWithNibName:@"FourthViewController" bundle:nil];
    UINavigationController *fourthNavigationController = [[InteractivePopNavigationController alloc]
                                                          initWithRootViewController:fourthViewController];
    fourthNavigationController.navigationBar.tintColor = [UIColor whiteColor];

    BaseTabBarController *tabBarController = [[BaseTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController, fourthNavigationController]];
    self.viewController = tabBarController;
    
    NSUInteger tabBarViewControllersCount = tabBarController.viewControllers.count;
    
    NSMutableArray *tbHighlightArray = [NSMutableArray arrayWithCapacity:tabBarViewControllersCount];
    for (int i=0; i<tabBarViewControllersCount; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tbHighlight%d",i]];
        [tbHighlightArray addObject:image];
    }
    [tabBarController setItemHighlightedImages:tbHighlightArray];

    NSMutableArray *tbNormalArray = [NSMutableArray arrayWithCapacity:tabBarViewControllersCount];
    for (int i=0; i<tabBarViewControllersCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tbNormal%d",i]];
        [tbNormalArray addObject:image];
    }
    [tabBarController setItemImages:tbNormalArray];
    
    NSArray *titleArr = @[@"首页", @"订单", @"优+", @"我的"];
    [tabBarController setTabBarItemsTitle:titleArr];
    tabBarController.delegate = (id<UITabBarControllerDelegate>) self;
    [tabBarController setTabBarBackgroundImage:[UIImage imageNamed:@"tb_bg"]];
    [tabBarController removeSelectionIndicator];
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[shareFun imageWithColor:kRGBCOLOR(215, 61, 67)] forBarMetrics:UIBarMetricsDefault];
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)]) {
        [navigationBarAppearance setShadowImage:[[UIImage alloc] init]];
    }

//    [navigationBarAppearance setBarTintColor:kRGBCOLOR(215, 61, 67)];
    
    NSDictionary *textAttributes = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
    }
    else {
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

- (void)setupShareSDK {
    [ShareSDK registerApp:@"84adffe528ef"];     //参数为ShareSDK官网中添加应用后得到的AppKey
    [ShareSDK connectWeChatWithAppId:@"wx077c74b100faad46"
                           appSecret:@"b533a30e685ea2ee7c2056d763392183"
                           wechatCls:[WXApi class]];
    [ShareSDK connectQZoneWithAppKey:@"101042768"
                           appSecret:@"34ffcba4133eae940e4f2e15697c0488"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}

- (void)setupBaiduMap {
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"eeRkTFfobP50mGGE3vbVuAao"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)getLoginState {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/session/is-login", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [PublicInstance instance].isLogin = NO;
        }
        else {
            [PublicInstance instance].isLogin = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [PublicInstance instance].isLogin = NO;
//        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)checkUpdate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/app-ios-version/version", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self useData:tDic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"获取版本信息失败"];
    }];
}

- (void)useData:(NSDictionary *)dic {
    NSDictionary *versionDic = [dic objectForKey:@"version"];
    NSString *iosVersion = versionDic[@"iosVersion"];
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSComparisonResult result = [iosVersion compare:localVersion];
    if (result == NSOrderedDescending) {
        _url = versionDic[@"iosUrl"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发现新版本，是否更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }
}

@end
