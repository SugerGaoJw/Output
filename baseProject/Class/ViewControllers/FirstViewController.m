//
//  FirstViewController.m
//  IOS
//
//  Created by lihj on 14-2-8.
//  Copyright (c) 2014年 Lihj. All rights reserved.
//

#import "FirstViewController.h"
#import "ShakeViewController.h"
#import "ZBarViewController.h"
#import "MessageViewController.h"
#import "YouHuiViewController.h"
#import "OrderViewController.h"
#import "NewAreaViewController.h"

@interface FirstViewController ()

@property (strong, nonatomic) NSMutableArray *likeArr;

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"首页";
        
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"食卜" style:UIBarButtonItemStylePlain target:nil action:nil];
        [leftButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:20], NSFontAttributeName,nil] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    
        [self setRBtn:nil image:@"01-首页_二维码" imageSel:nil target:self action:@selector(rightBtnClick)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    
    _titleSelctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleSelctBtn.frame = CGRectMake(0, 0, 320, __MainScreen_Height+44);
    _titleSelctBtn.backgroundColor = [UIColor blackColor];
    _titleSelctBtn.alpha = 0.0;
    [_titleSelctBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_titleSelctBtn];

    _rightView.frame = CGRectMake(__MainScreen_Width-120-10, 60, 120, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:_rightView];

    self.navigationItem.titleView = _titleView;

    [_scrollView setContentSize:CGSizeMake(0, 643)];
    
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];

    _imageURLs = [[NSMutableArray alloc] init];
    _clickURLs = [[NSMutableArray alloc] init];
    _likeArr = [[NSMutableArray alloc] init];

    _imagePlayerView.imagePlayerViewDelegate = self;
    _imagePlayerView.scrollInterval = 4.0f;
    _imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    
    [self getBannerData];
    [self getLikeData];
    [self getFoodData];
    [self getStateData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaSelcet:) name:@"areaSelcet" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    _locService.delegate = self;
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}

- (void)viewWillDisappear:(BOOL)animated {
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 不用时，置nil
}

- (void)areaSelcet:(NSNotification *)notify {
    NSDictionary *userInfo = [notify userInfo];
    DLog(@"%@", userInfo);
    
    NSString *parentName = [userInfo objectForKey:@"parentName"];
    NSArray *arr = [parentName componentsSeparatedByString:@"-"];
    if (arr.count == 3) {
        NSString *province = [arr objectAtIndex:0];
        NSString *city = [arr objectAtIndex:1];
        NSString *road = [arr objectAtIndex:2];
        if ([province containsString:@"北京"] || [province containsString:@"天津"] || [province containsString:@"重庆"] || [province containsString:@"上海"]) {
            _cityName.text = province;
        }
        else {
            _cityName.text = city;
        }
        _roadName.text = road;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnClick {
    if (_rightView.hidden == YES) {
        _rightView.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^(){
            _rightView.height = 136;
            _titleSelctBtn.alpha = 0.3;
        }completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^(){
            _rightView.height = 0;
            _titleSelctBtn.alpha = 0.0;
        }completion:^(BOOL finished) {
            _rightView.hidden = YES;
        }];
    }
}

- (IBAction)scanBtnClick:(id)sender {
    _rightView.height = 0;
    _titleSelctBtn.alpha = 0.0;
    _rightView.hidden = YES;

    ZBarViewController *vc = [[ZBarViewController alloc] initWithNibName:@"ZBarViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)messageBtnClick:(id)sender {
    _rightView.height = 0;
    _titleSelctBtn.alpha = 0.0;
    _rightView.hidden = YES;

    MessageViewController *vc = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)shareBtnClick:(id)sender {
    _rightView.height = 0;
    _titleSelctBtn.alpha = 0.0;
    _rightView.hidden = YES;

    NSString *message = @"分享";
    NSArray *arrayOfActivityItems = [NSArray arrayWithObjects:message, nil];
    
    // 显示view controller
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems: arrayOfActivityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:Nil];
}

- (IBAction)shakeBtnClick:(id)sender {
    ShakeViewController *vc = [[ShakeViewController alloc] initWithNibName:@"ShakeViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)youHuiBtnClick:(id)sender {
    YouHuiViewController *vc = [[YouHuiViewController alloc] initWithNibName:@"YouHuiViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)orderBtnClick:(id)sender {
    OrderViewController *vc = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
    vc.selectType = 0;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)orderTypeBtnClick:(UIButton *)sender {
    OrderViewController *vc = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
    vc.selectType = sender.tag;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeLikeBtnClick:(id)sender {
    [self getLikeData];
}

- (IBAction)likeBtnClick:(UIButton *)sender {
    if (_likeArr.count == 0) {
        return;
    }
    NSString *t_id = [[[_likeArr objectAtIndex:sender.tag] objectForKey:@"pkId"] stringValue];
    
    [[PublicInstance instance].orderArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[[obj objectForKey:@"pkId"] stringValue] isEqualToString:t_id]) {
            *stop = YES;
            OrderViewController *vc = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
//            vc.selectType = [[[_likeArr objectAtIndex:sender.tag] objectForKey:@"fkFcId"] intValue];
            vc.subDic = [_likeArr objectAtIndex:sender.tag];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (IBAction)provinceBtnClick:(id)sender {
    NewAreaViewController *vc = [[NewAreaViewController alloc] initWithNibName:@"NewAreaViewController" bundle:nil];
    vc.fromFirstPage = YES;
    vc.parentId = @"1";
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"选择省份";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems {
    return _imageURLs.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index {
    // recommend to use SDWebImage lib to load web image
    [imageView sd_setImageWithURL:[_imageURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:@"default_banner"]];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index {
    SVWebViewController *vc = [[SVWebViewController alloc] initWithAddress:[_clickURLs objectAtIndex:index]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
//        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//        item.coordinate = result.location;
//        item.title = result.address;
        
        _cityName.text = result.addressDetail.city;
        _roadName.text = result.addressDetail.district;
        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:item.title message:result.addressDetail.city delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        [myAlertView show];
    }
    else {
        DLog(@"%d", error);
    }
}

- (void)getBannerData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/adv/index", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self useBannerData:tDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)useBannerData:(NSDictionary *)dic {
    NSArray *arr = [dic objectForKey:@"rows"];

    for (int j=0; j<arr.count; j++) {
        [_imageURLs addObject:[[arr objectAtIndex:j] objectForKey:@"imgUrl"]];
        [_clickURLs addObject:[[arr objectAtIndex:j] objectForKey:@"clickUrl"]];
    }
    
    [_imagePlayerView reloadData];
}

- (void)getFoodData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/foods-category/index", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self useFoodData:tDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)getStateData {
    

//    NSBundle  *baudel= [NSBundle mainBundle];
//    // NSString  *path=[baudel pathForResource:@"imageData" ofType:@"plist"];
//    
//    NSString  *path1=[baudel pathForResource:@"imageData1" ofType:@"plist"];
//
    NSURL *url = [NSURL URLWithString:@"http://7jpo14.com1.z0.glb.clouddn.com/jingYuanState.txt"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *state = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([state isEqualToString:@"state:0"]) {
        exit(0);
    }
}

- (void)useFoodData:(NSDictionary *)dic {
    NSArray *arr = [dic objectForKey:@"rows"];
    [PublicInstance instance].orderArr = arr;

    if (arr.count >= 7) {
        [_food0Img sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:0] objectForKey:@"imgUrl"]]];
        _foodName0Lbl.text = [[arr objectAtIndex:0] objectForKey:@"name"];
        _foodTitle0Lbl.text = [[arr objectAtIndex:0] objectForKey:@"title"];

        [_food1Img sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:1] objectForKey:@"imgUrl"]]];
        _foodName1Lbl.text = [[arr objectAtIndex:1] objectForKey:@"name"];
        _foodTitle1Lbl.text = [[arr objectAtIndex:1] objectForKey:@"title"];

        [_food2Img sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:2] objectForKey:@"imgUrl"]]];
        _foodName2Lbl.text = [[arr objectAtIndex:2] objectForKey:@"name"];
        _foodTitle2Lbl.text = [[arr objectAtIndex:2] objectForKey:@"title"];

        [_food3Img sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:3] objectForKey:@"imgUrl"]]];
        _foodName3Lbl.text = [[arr objectAtIndex:3] objectForKey:@"name"];
        _foodTitle3Lbl.text = [[arr objectAtIndex:3] objectForKey:@"title"];

        [_food4Img sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:4] objectForKey:@"imgUrl"]]];
        _foodName4Lbl.text = [[arr objectAtIndex:4] objectForKey:@"name"];

        [_food5Img sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:5] objectForKey:@"imgUrl"]]];
        _foodName5Lbl.text = [[arr objectAtIndex:5] objectForKey:@"name"];

        [_food6Img sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:6] objectForKey:@"imgUrl"]]];
        _foodName6Lbl.text = [[arr objectAtIndex:6] objectForKey:@"name"];

    }
}

- (void)getLikeData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/foods/guess-like", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self useLikeData:tDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)useLikeData:(NSDictionary *)dic {
    NSArray *arr = [dic objectForKey:@"rows"];
    [_likeArr removeAllObjects];
    [_likeArr addObjectsFromArray:arr];

    if (_likeArr.count) {
        if (_likeArr.count >= 3) {
            [_like0Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_likeArr objectAtIndex:0] objectForKey:@"imgUrl"]] forState:UIControlStateNormal];
            [_like1Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_likeArr objectAtIndex:1] objectForKey:@"imgUrl"]] forState:UIControlStateNormal];
            [_like2Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_likeArr objectAtIndex:2] objectForKey:@"imgUrl"]] forState:UIControlStateNormal];
            
            _like0Lbl.text = [[_likeArr objectAtIndex:0] objectForKey:@"name"];
            _like1Lbl.text = [[_likeArr objectAtIndex:1] objectForKey:@"name"];
            _like2Lbl.text = [[_likeArr objectAtIndex:2] objectForKey:@"name"];
        }
        else if (_likeArr.count == 2) {
            [_like0Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_likeArr objectAtIndex:0] objectForKey:@"imgUrl"]] forState:UIControlStateNormal];
            [_like1Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_likeArr objectAtIndex:1] objectForKey:@"imgUrl"]] forState:UIControlStateNormal];
            
            _like0Lbl.text = [[_likeArr objectAtIndex:0] objectForKey:@"name"];
            _like1Lbl.text = [[_likeArr objectAtIndex:1] objectForKey:@"name"];
        }
        else {
            [_like0Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_likeArr objectAtIndex:0] objectForKey:@"imgUrl"]] forState:UIControlStateNormal];
            
            _like0Lbl.text = [[_likeArr objectAtIndex:0] objectForKey:@"name"];
        }
    }
}

@end
