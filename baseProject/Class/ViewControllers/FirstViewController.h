//
//  FirstViewController.h
//  IOS
//
//  Created by lihj on 14-2-8.
//  Copyright (c) 2014年 Lihj. All rights reserved.
//

#import "BaseViewController.h"
#import "ImagePlayerView.h"
#import "BMapKit.h"

@interface FirstViewController : BaseViewController <ImagePlayerViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate> {
    
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    
    IBOutlet UILabel *_cityName;
    IBOutlet UILabel *_roadName;
    

    IBOutlet UIScrollView *_scrollView;
    IBOutlet ImagePlayerView *_imagePlayerView;
    
    NSMutableArray *_imageURLs;
    NSMutableArray *_clickURLs;
    IBOutlet UIView *_titleView;
    IBOutlet UIView *_rightView;
    UIButton *_titleSelctBtn;
    
    IBOutlet UIButton *_like0Btn;
    IBOutlet UIButton *_like1Btn;
    IBOutlet UIButton *_like2Btn;
    IBOutlet UILabel *_like0Lbl;
    IBOutlet UILabel *_like1Lbl;
    IBOutlet UILabel *_like2Lbl;
    
    IBOutlet UIImageView *_food0Img;
    IBOutlet UILabel *_foodName0Lbl;
    IBOutlet UILabel *_foodTitle0Lbl;

    IBOutlet UIImageView *_food1Img;
    IBOutlet UILabel *_foodName1Lbl;
    IBOutlet UILabel *_foodTitle1Lbl;

    IBOutlet UIImageView *_food2Img;
    IBOutlet UILabel *_foodName2Lbl;
    IBOutlet UILabel *_foodTitle2Lbl;

    IBOutlet UIImageView *_food3Img;
    IBOutlet UILabel *_foodName3Lbl;
    IBOutlet UILabel *_foodTitle3Lbl;

    IBOutlet UIImageView *_food4Img;
    IBOutlet UILabel *_foodName4Lbl;

    IBOutlet UIImageView *_food5Img;
    IBOutlet UILabel *_foodName5Lbl;

    IBOutlet UIImageView *_food6Img;
    IBOutlet UILabel *_foodName6Lbl;

}


@end
