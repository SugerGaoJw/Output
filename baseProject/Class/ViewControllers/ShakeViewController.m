//
//  ShakeViewController.m
//  baseProject
//
//  Created by Li on 15/1/8.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "ShakeViewController.h"
#import "ShakePopViewController.h"
#import "UIViewController+CustomPopupViewController.h"
#import "MyCouponViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ShakeViewController () {
    BOOL _canShake;
}

@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"摇一摇";
    
    _canShake = YES;
    [self setRBtn:nil image:@"06-摇一摇_分享" imageSel:nil target:self action:@selector(shareSth)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - share
- (void)shareSth
{
    NSString *message = @"分享";
    NSArray *arrayOfActivityItems = [NSArray arrayWithObjects:message, nil];
    
    // 显示view controller
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems: arrayOfActivityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:Nil];
}
#pragma mark -
#pragma mark yaoyiyao
- (BOOL)canBecomeFirstResponder {
    return YES;// default is NO
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    DLog(@"开始摇动手机");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    DLog(@"摇完了");
//    UIAlertView *yaoyiyao = [[UIAlertView alloc]initWithTitle:@"温馨提示：" message:@"您摇动了手机，想干嘛？" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles: nil];
//    [yaoyiyao show];
    
    if (_canShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self getData];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消");
}

- (void)getData {
    _canShake = NO;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/shake/shake", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self useData:tDic];
        }
        _canShake = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        _canShake = YES;
    }];
}

- (void)useData:(NSDictionary *)dic {
    
    dic = [dic objectForKey:@"data"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"couponStartTime"]];
    NSDate *date1 = [dateFormatter dateFromString:[dic objectForKey:@"couponEndTime"]];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSString *dateStr1 = [dateFormatter stringFromDate:date1];

    ShakePopViewController *vc = [[ShakePopViewController alloc] initWithNibName:@"ShakePopViewController" bundle:nil];
    vc.view.backgroundColor = [UIColor clearColor];
    [vc.disMissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [vc.lookBtn addTarget:self action:@selector(lookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    vc.tipLbl0.text = [NSString stringWithFormat:@"恭喜您获得 %@ 请查看！", [dic objectForKey:@"couponName"]];
    vc.tipLbl1.text = [NSString stringWithFormat:@"此券可抵%@%@，适用于%@", [dic objectForKey:@"couponPrice"], [dic objectForKey:@"couponType"], [dic objectForKey:@"couponUseRegionDescription"]];
    vc.tipLbl2.text = [NSString stringWithFormat:@"使用时间：%@-%@", dateStr, dateStr1];
    [self presentPopupView:vc.view animationType:CustomPopupViewAnimationFade];

}

- (void)dismissBtnClick {
    [self dismissPopupViewControllerWithanimationType:CustomPopupViewAnimationFade];
}

- (void)lookBtnClick {
    [self dismissBtnClick];
    MyCouponViewController *vc = [[MyCouponViewController alloc] initWithNibName:@"MyCouponViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
