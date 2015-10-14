//
//  MeshPointInquiryViewController.m
//  baseProject
//
//  Created by Li on 15/1/8.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MeshPointInquiryViewController.h"
#import "PlaceMark.h"
#import "MeshDetailViewController.h"

@interface MeshPointInquiryViewController () {
}

@end

@implementation MeshPointInquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"网点查询";
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-44)];
    [self.view addSubview:_mapView];
    
    centerRoutes = [[NSMutableArray alloc] init];

    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[PlaceMark class]])
    {
        BMKAnnotationView *pinView = (BMKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"MKAnnotationView"];
        if (pinView == nil)
        {
            pinView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
        }
        else
        {
            pinView.annotation = annotation;
        }
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"地图定位"];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightBtn.tag = [(PlaceMark *)annotation mTag];
        [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightBtn;
        
        return pinView;
    }
    return nil;
}

- (void)rightBtnClick:(UIButton *)sender {
    MeshDetailViewController *vc = [[MeshDetailViewController alloc] initWithNibName:@"MeshDetailViewController" bundle:nil];
    vc.dataDic = [self.dataSource objectAtIndex:sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

//地图视图大小范围
- (void)centerMap
{
    BMKCoordinateRegion region;
    
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
    for(int idx = 0; idx < centerRoutes.count; idx++)
    {
        CLLocation* currentLocation = [centerRoutes objectAtIndex:idx];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    
    region.span.latitudeDelta  = 0.015;
    region.span.longitudeDelta = 0.015;
    
    [_mapView setRegion:region animated:YES];
}

- (void)getData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/store/page", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)useData:(NSDictionary *)dic {
    NSArray *arr = [dic objectForKey:@"rows"];
    [self.dataSource addObjectsFromArray:arr];
    
    for (int i=0; i<self.dataSource.count; i++) {
        NSDictionary *dic = [self.dataSource objectAtIndex:i];
        NSString *lat = [[dic objectForKey:@"latitude"] stringValue];
        NSString *lng = [[dic objectForKey:@"longitude"] stringValue];
        if (lng.length && lat.length) {
            Place* t_place = [[Place alloc] init];
            t_place.name = [dic objectForKey:@"name"];
            t_place.description = [dic objectForKey:@"address"];
            t_place.latitude = [lat doubleValue];
            t_place.longitude = [lng doubleValue];
            
            PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
//            t_placeMark.leftImgStr = [dic objectForKey:@"logo"];
            t_placeMark.mTag = i;
            [_mapView addAnnotation:(id <BMKAnnotation>)t_placeMark];
            
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:t_place.latitude longitude:t_place.longitude];
            [centerRoutes addObject:loc];
        }
    }
    
    if (centerRoutes.count) {
        [self centerMap];
    }
}

@end
