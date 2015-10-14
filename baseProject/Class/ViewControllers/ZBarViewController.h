//
//  ZBarViewController.h
//  XMU1.0
//
//  Created by lihj on 13-8-14.
//  Copyright (c) 2013年 DongXM. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBarSDK.h"

@interface ZBarViewController : BaseViewController <ZBarReaderDelegate, ZBarReaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{
    
    IBOutlet ZBarReaderView *_readerView;
    ZBarCameraSimulator *_cameraSim;
    
    IBOutlet UIImageView *bgImgView;
    IBOutlet UIImageView *_scanImgView;
    
    BOOL ifBack;
    
    NSString *_url;
}

@end
