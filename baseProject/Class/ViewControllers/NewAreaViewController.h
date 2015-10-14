//
//  NewAreaViewController.h
//  baseProject
//
//  Created by Li on 15/3/17.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BaseViewController.h"


@interface NewAreaViewController : BaseViewController {
    
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *parentName;

@property (nonatomic, assign) BOOL fromFirstPage;

@end
