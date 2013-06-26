//
//  OnlineSearchViewController.h
//  cbeta
//
//  Created by chao he on 10-7-12.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OnlineSearchViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
	
	UITableView *m_tableView;
	UISearchBar *m_searchBar;
	
	NSMutableArray *m_resultLectionArray;       //接受检索结果
	NSMutableArray *m_resultVolumnNo;           //接受检索卷结果
	NSArray *m_lectionArray;                    //经文数组
	
}

@property (nonatomic ,retain) IBOutlet UITableView *m_tableView;
@property (nonatomic ,retain) IBOutlet UISearchBar *m_searchBar;

@property (nonatomic ,retain)  NSMutableArray *m_resultLectionArray;
@property (nonatomic ,retain)  NSMutableArray *m_resultVolumnNo; 
@property (nonatomic ,retain)  NSArray *m_lectionArray;

-(void)handleSearchForItem:(NSString *)searchItem;

@end
