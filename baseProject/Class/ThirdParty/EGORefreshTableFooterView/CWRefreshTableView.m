//
//  CWRefreshTableView.h
//  IOS
//
//  Created by lihj on 5-10-14.
//  Copyright 2014 lihj. All rights reserved.
//

#import "CWRefreshTableView.h"

@interface CWRefreshTableView()

- (void) initControl;
- (void) initPullDownView;
- (void) initPullUpView;
- (void) initPullAllView;
- (void) updatePullViewFrame;

@end

@implementation CWRefreshTableView

- (id)initWithTableView:(UITableView *)tableView pullDirection:(CWRefreshTableViewDirection)direction {
    if ((self = [super init])) {
		_currentPageIndex = 1;
		_totalPage = 0;
        _pullScrollView = (UIScrollView*)tableView;
        _direction = direction;
        [self initControl];
    }	
    return self;	
}

- (id)initWithScrollView:(UIScrollView *)scrollView pullDirection:(CWRefreshTableViewDirection)direction {
    if ((self = [super init])) {
		_currentPageIndex = 1;
		_totalPage = 0;
        _pullScrollView = scrollView;
        _direction = direction;
        [self initControl];
    }
    return self;
}

- (void)setTotalPage:(int)totalPage {
    _totalPage = totalPage;
}

#pragma mark private

- (void) initControl {
    switch (_direction) {			
        case CWRefreshTableViewDirectionUp:			
            [self initPullUpView];		
            break;
        case CWRefreshTableViewDirectionDown:			
            [self initPullDownView];			
            break;
        case CWRefreshTableViewDirectionAll:			
            [self initPullAllView];			
            break;			
    }	
}

- (void)initPullDownView {
    CGFloat fWidth = _pullScrollView.frame.size.width;		
	
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -60.0, fWidth, 60.0) 
																		   byDirection:EGOOPullRefreshDown];	
    view.delegate = self;	
    [_pullScrollView addSubview:view];	
    view.autoresizingMask = _pullScrollView.autoresizingMask;	
    _headView = view;	
    [_headView refreshLastUpdatedDate];
}

- (void)initPullUpView {
    CGFloat fWidth = _pullScrollView.frame.size.width;
    CGFloat originY = _pullScrollView.contentSize.height;	
    CGFloat originX = _pullScrollView.contentOffset.x;	
    if (originY < _pullScrollView.frame.size.height) {		
        originY = _pullScrollView.frame.size.height;		
    }

    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(originX, originY, fWidth, 60)
																		  byDirection:EGOOPullRefreshUpLoadMore];
    view.delegate = self;	
    [_pullScrollView addSubview:view];	
    view.autoresizingMask = _pullScrollView.autoresizingMask;	
    _footerView = view;	
    [_footerView refreshLastUpdatedDate];
}

- (void)initPullAllView {
    [self initPullUpView];	
    [self initPullDownView];	
}

- (void)updatePullViewFrame {
    if (_footerView != nil) {
        CGFloat fWidth = _pullScrollView.frame.size.width;		
        CGFloat originY = _pullScrollView.contentSize.height;		
        CGFloat originX = _pullScrollView.contentOffset.x;		
        if (originY < _pullScrollView.frame.size.height) {			
            originY = _pullScrollView.frame.size.height;
        }
		
        if (!CGRectEqualToRect(_footerView.frame, CGRectMake(originX, originY, fWidth, 60))) {			
			_footerView.frame = CGRectMake(originX, originY, fWidth, 60);  			
        }		
    }	
}

- (void)reload{
    [_headView doDownRefreshLoading:nil];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < -60.0f) {		
		[_headView egoRefreshScrollViewDidScroll:scrollView];  		
    }	
    else if (scrollView.contentOffset.y > 60.0f) {
		if (_currentPageIndex < _totalPage){
			[_footerView egoRefreshScrollViewDidScroll:scrollView];
		}
        else {
			[_footerView setStatusText:@"已经是最后一条记录了"];
		}
    }	
    [self updatePullViewFrame];	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < -60.0f) {		
        [_headView egoRefreshScrollViewDidEndDragging:scrollView];  		
    }	
    else if (scrollView.contentOffset.y > 10.0f)	
    {		
		if (_currentPageIndex < _totalPage) {
			[_footerView egoRefreshScrollViewDidEndDragging:scrollView];		
		}
        else {
			[_footerView setStatusText:@"已经是最后一条记录了"];
		}	
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)dataSourceDidFinishedLoading {
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:_pullScrollView];	
    [_footerView egoRefreshScrollViewDataSourceDidFinishedLoading:_pullScrollView];	
    [self updatePullViewFrame];
    _reloading = NO;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view 
                                     direction:(EGOPullRefreshDirection)direc{	
	_reloading = YES;
	if (_delegate && [_delegate respondsToSelector:@selector(CWRefreshTableViewReloadTableViewDataSource:)]) {
        if (direc == EGOOPullRefreshUpLoadMore && _currentPageIndex < _totalPage) {
			_currentPageIndex = _currentPageIndex + 1; //记录页索引
            [_delegate CWRefreshTableViewReloadTableViewDataSource:CWRefreshTableViewPullTypeLoadMore];	
        }		
        else if (direc == EGOOPullRefreshDown) {	
            [_delegate CWRefreshTableViewReloadTableViewDataSource:CWRefreshTableViewPullTypeReload];			
        }
    }
 }

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{	
	return _reloading; // should return if data source model is reloading	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{	
	return [NSDate date]; // should return date data source was last changed	
}

@end
