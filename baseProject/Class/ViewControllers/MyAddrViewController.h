//
//  MyAddrViewController.h
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"
/*!
 *  送餐地址管理类
 */
typedef void(^DidSelCellBlock)(NSDictionary * cellDataSource);
@interface MyAddrViewController : BaseViewController <CWRefreshTableViewDelegate> {
    
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (copy ,nonatomic)DidSelCellBlock blkDidSelCell;
@end
