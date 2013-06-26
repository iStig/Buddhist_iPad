//
//  DownloadBookMarkController.m
//  CbetaIpad
//
//  Created by xmforce on 10-9-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownloadBookMarkController.h"
#import "BookMarkEditController.h"
#import "CbetaIpadAppDelegate.h"
#import "DownReadViewController.h"


@implementation DownloadBookMarkController
@synthesize tableView = _tableView;
@synthesize bookMarkArray = _bookMarkArray;
@synthesize bookMarkFilePath = _bookMarkFilePath;

-(void)viewDidLoad{
	[super viewDidLoad];
	
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [docPaths objectAtIndex:0];
	
	_bookMarkFilePath = [[docDirectory stringByAppendingPathComponent:bookmarksFileName]copy];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:self.bookMarkFilePath]) {
		_bookMarkArray = [[NSMutableArray alloc]initWithContentsOfFile:self.bookMarkFilePath];
	}else {
		_bookMarkArray = [[NSMutableArray alloc]initWithObjects:nil];
	}
	
	self.contentSizeForViewInPopover = CGSizeMake(320, 370);
	_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 370.0) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = backItem;
	[backItem release];
	
	[super viewDidLoad];
}

-(void)dealloc{
	[_tableView release];
	[_bookMarkArray release];
	[_bookMarkFilePath release];
	[super dealloc];
}


-(void)addBookMark{
	CbetaIpadAppDelegate *delegate = [CbetaIpadAppDelegate sharedAppDelegate];
	DownReadViewController *downReadViewController = (DownReadViewController *)[delegate.tabBarController.viewControllers objectAtIndex:1];
	
	//check if the bookmark exists
	for( int i = 0; i<[_bookMarkArray count]; i++) 
	{
		NSDictionary *existPageMark = [_bookMarkArray objectAtIndex:i];
		if (([downReadViewController.m_volumnNo isEqualToString:[existPageMark valueForKey:k_volumnNo]]) 
			&& ([downReadViewController.m_lectionNo isEqualToString:[existPageMark valueForKey:k_lectionNo]])
			&&( [downReadViewController.m_subvolumnNo isEqualToString:[existPageMark valueForKey:k_subvolumnNo]])
			&&( [downReadViewController.m_lectionName isEqualToString:[existPageMark valueForKey:k_lectionName]])
			&&( [[NSString stringWithFormat:@"%d",downReadViewController.m_leavesView.currentPageIndex] isEqualToString:[existPageMark valueForKey:k_pageIndex]]))
		{
			return;	
		}
		
	}
	
	NSMutableDictionary *dictPagemark= [[NSMutableDictionary alloc] init];
	[dictPagemark setValue: downReadViewController.m_volumnNo forKey:k_volumnNo];
	[dictPagemark setValue: downReadViewController.m_lectionNo forKey:k_lectionNo];
	[dictPagemark setValue: downReadViewController.m_subvolumnNo forKey:k_subvolumnNo];
	[dictPagemark setValue: downReadViewController.m_lectionName forKey:k_lectionName];
	[dictPagemark setValue: [NSString stringWithFormat:@"%d",downReadViewController.m_leavesView.currentPageIndex] forKey:k_pageIndex];
	[self.bookMarkArray addObject:dictPagemark];
	
	[self.bookMarkArray writeToFile:_bookMarkFilePath atomically:NO];
	[downReadViewController.m_bookMarkPopoverController dismissPopoverAnimated:YES];
	
	[dictPagemark release];
}

#pragma mark -
#pragma mark TableView Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *BOOK_MARK_IDENTIFIER = @"BOOK_MARK_IDENTIFIER";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BOOK_MARK_IDENTIFIER];
	if (cell == nil) {
		cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
													 reuseIdentifier:BOOK_MARK_IDENTIFIER]autorelease];
	}
	if ([indexPath row] == 0) {
		cell.textLabel.text = @"加入書簽";
		cell.accessoryType = UITableViewCellAccessoryNone;
	}else if ([indexPath row] == 1) {
		cell.textLabel.text = @"查看書簽";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return 2;
}

#pragma mark -
#pragma mark  TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;
	if (row == 0) {
		[self addBookMark];
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"\n加入書簽成功\n" delegate:nil cancelButtonTitle:@"繼續閱讀" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}else if (row == 1) {
		BookMarkEditController *editController = [[BookMarkEditController alloc]init];
		editController.bookMarkArray = self.bookMarkArray;
		[self.navigationController pushViewController:editController animated:YES];
		[editController release];
	}

}
@end
