//
//  MeshPointInquiryViewController.h
//  baseProject
//
//  Created by Li on 15/1/8.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"
#import "BMapKit.h"

@interface MeshPointInquiryViewController : BaseViewController <BMKMapViewDelegate>{
    BMKMapView* _mapView;
    
    NSMutableArray *centerRoutes;
}

@end
