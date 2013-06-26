//
//  DownloadBookMarkController.h
//  CbetaIpad
//
//  Created by xmforce on 10-9-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define bookmarksFileName   @"bookmarks.plist"

#define k_volumnNo          @"volumnNo"
#define k_lectionNo			@"lectionNo"
#define k_subvolumnNo		@"subvolumnNo"
#define k_lectionName		@"lectionName"
#define k_pageIndex			@"currentPageIndex"

@interface DownloadBookMarkController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	UITableView *_tableView;	
	NSMutableArray *_bookMarkArray;//bookmarks added by the user
	NSString *_bookMarkFilePath;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *bookMarkArray;
@property (nonatomic, retain) NSString *bookMarkFilePath;

@end
