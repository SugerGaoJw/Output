//
//  ZBarViewController.m
//  XMU1.0
//
//  Created by lihj on 13-8-14.
//  Copyright (c) 2013年 DongXM. All rights reserved.
//

#import "ZBarViewController.h"
#import "UIImage+Scale.h"

@interface ZBarViewController ()

@end

@implementation ZBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_readerView start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"扫一扫";
    
    _readerView.readerDelegate = self;
    _readerView.torchMode = 0;          //闪光灯。默认关闭
    _readerView.allowsPinchZoom = YES;
    //矩形框扫描。添加扫描范围
//    CGRect scanMaskRect = CGRectMake(30, (__MainScreen_Height-44)/2 - 250*__MainScreen_Height/460/2, 260, 250*__MainScreen_Height/460);
//    _readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:_readerView.bounds];
    
    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        _cameraSim = [[ZBarCameraSimulator alloc] initWithViewController: self];
        _cameraSim.readerView = _readerView;
    }
    [self scan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    _readerView = nil;
    bgImgView = nil;
    _scanImgView = nil;
    [super viewDidUnload];
}

- (void)backAction {
    ifBack = YES;
    [_readerView stop];
    [_readerView removeFromSuperview];
    [super backAction];
}

- (void)moreBtnClick {    
    UIActionSheet *t_ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"闪光灯", nil];
    [t_ac setActionSheetStyle:UIActionSheetStyleAutomatic];
    [t_ac showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
//        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//        picker.delegate = self;
//        picker.sourceType = sourceType;
//        [self presentModalViewController:picker animated:YES];
//    }
//    else if (buttonIndex == 1){
        _readerView.torchMode  = !_readerView.torchMode;
    }
}

- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds {
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    DLog(@"%f,%f,%f,%f", x, y, width, height);

    return CGRectMake(x, y, width, height);
}

- (void)scan {
    int h = 0;
    if (__MainScreen_Height == 548) {
        h = 20;
    }
    [UIView animateWithDuration:1.5 animations:^(){
        if (_scanImgView.frame.origin.y > __MainScreen_Height/2) {
            _scanImgView.top = __MainScreen_Height/2-135-h;
        }
        else {
            _scanImgView.top = __MainScreen_Height/2+50+h;
        }
    }completion:^(BOOL finish) {
        if (!ifBack) {
            [self scan];
        }
    }];
}

- (void)readerView:(ZBarReaderView*)readerView didReadSymbols:(ZBarSymbolSet*)symbols fromImage:(UIImage*)image {
    for(ZBarSymbol *symbol in symbols) {
        // 识别扫描后的信息类型
        NSString *symbolStr = symbol.data;
        
//        // zbar是日本人开发的，需要将默认的日文编码改为UTF8，否则扫描“坑爹”和“尼玛啊”等会出现乱码
//        if ([symbolStr canBeConvertedToEncoding:NSShiftJISStringEncoding])
//        {
//            symbolStr = [NSString stringWithCString:[symbolStr cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
//        }
//        DLog(@"%@", symbolStr);
        [self scanSuccess:symbolStr];
        break;
    }
    [readerView stop];
}

- (void)scanSuccess:(NSString *)str {
    ifBack = NO;

    if ([str hasPrefix:@"http://"] || [str hasPrefix:@"www."] || [str hasPrefix:@"https://"])
    {
        if ([str hasPrefix:@"www."]) {
            str = [NSString stringWithFormat:@"http://%@", str];
        }
        _url = str;
        
        SVWebViewController *vc = [[SVWebViewController alloc] initWithAddress:_url];
        [self.navigationController pushViewController:vc animated:YES];

//        NSString *tisp = [NSString stringWithFormat:@"是否打开此链接？\r\n%@", str];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:tisp delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alertView setTag:1000];
//        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"复制内容", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:_url]];
        }
    }
    else {
        if (buttonIndex == 1) {
            UIPasteboard *pasterboard = [UIPasteboard generalPasteboard];
            pasterboard.string = alertView.message;
        }
    }
    [_readerView flushCache];
    [_readerView start];
}

@end
