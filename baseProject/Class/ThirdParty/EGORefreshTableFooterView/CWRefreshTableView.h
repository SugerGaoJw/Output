//
//  CWRefreshTableView.h
//  IOS
//
//  Created by lihj on 5-10-14.
//  Copyright 2014 lihj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGORefreshTableHeaderView.h"

/**
 *  方向
 */
typedef enum {
    CWRefreshTableViewDirectionUp,
    CWRefreshTableViewDirectionDown,
    CWRefreshTableViewDirectionAll
}CWRefreshTableViewDirection;

/**
 *  拉动的类型
 */
typedef enum {
    CWRefreshTableViewPullTypeReload,           //下拉
    CWRefreshTableViewPullTypeLoadMore,         //上拉
}CWRefreshTableViewPullType;

@protocol CWRefreshTableViewDelegate;

@interface CWRefreshTableView : NSObject <EGORefreshTableHeaderDelegate, UIScrollViewDelegate> {
    BOOL                        _reloading;	
    EGORefreshTableHeaderView   *_headView;
    EGORefreshTableHeaderView   *_footerView;	
    CWRefreshTableViewDirection _direction;
}

@property (nonatomic, assign) id<CWRefreshTableViewDelegate> delegate;
@property (nonatomic, assign) UITableView                *pullTableView;
@property (nonatomic, assign) UIScrollView               *pullScrollView;
@property (nonatomic,assign ) int                        currentPageIndex;  //记录页索引
@property (nonatomic,assign ) int                        totalPage;         //总页数,第一次加载后得出

- (id)initWithTableView:(UITableView *)tableView pullDirection:(CWRefreshTableViewDirection)direction;
- (id)initWithScrollView:(UIScrollView *)scrollView pullDirection:(CWRefreshTableViewDirection)direction;

- (void)dataSourceDidFinishedLoading;
- (void)reload;

@end

@protocol CWRefreshTableViewDelegate <NSObject>

- (void)CWRefreshTableViewReloadTableViewDataSource:(CWRefreshTableViewPullType)refreshType;

@end
