//
//  DownSeachViewController.h
//  CbetaIpad
//
//  Created by yywang on 10-8-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DownSeachViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{

	UITableView *m_tableView;
	UISearchBar *m_searchBar;
	
	NSMutableArray *m_downResultLectionArray;       //接受检索结果
	NSMutableArray *m_downResultVolumnNo;           //接受检索卷结果
	NSArray *m_downLectionArray;                       //本地默认经文
}

@property (nonatomic ,retain) IBOutlet UITableView *m_tableView;
@property (nonatomic ,retain) IBOutlet UISearchBar *m_searchBar;

@property (nonatomic ,retain)  NSMutableArray *m_downResultLectionArray;
@property (nonatomic ,retain)  NSMutableArray *m_downResultVolumnNo; 
@property (nonatomic ,retain)  NSArray *m_downLectionArray;

-(void)handleSearchForDownLoadItem:(NSString *)searchItem;
@end
