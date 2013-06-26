//
//  BookMarkEditController.m
//  CbetaIpad
//
//  Created by xmforce on 10-9-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BookMarkEditController.h"
#import "PassParameter.h"
#import "Define.h"
#import "DownloadBookMarkController.h"

@implementation BookMarkEditController
@synthesize tableView = _tableView;
@synthesize bookMarkArray = _bookMarkArray;

-(void)viewDidLoad{
	self.contentSizeForViewInPopover = CGSizeMake(320, 370);
	_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 370.0) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	
	UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"刪除" style:UIBarButtonItemStyleBordered
																  target:self action:@selector(bookMarkEdit:)];
	self.navigationItem.rightBarButtonItem = deleteItem;
	[deleteItem release];
	
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

-(void)dealloc{
	[_tableView release];
	[_bookMarkArray release];
	[super dealloc];
}

-(IBAction)bookMarkEdit:(id)sender
{
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	if (self.tableView.editing) {
		[self.navigationItem.rightBarButtonItem setTitle:@"完成"];
	}
	else {
		[self.navigationItem.rightBarButtonItem setTitle:@"刪除"];
	}
}

-(void)displayBookMark:(NSUInteger)row{
	NSDictionary *dict= [self.bookMarkArray objectAtIndex:row];
	NSString *m_volumnNo=[dict objectForKey:k_volumnNo];
	NSString *strlectionNo=[dict objectForKey:k_lectionNo];
	NSString *m_subVolumnNo=[dict objectForKey:k_subvolumnNo];
	NSString *lectionName=[dict objectForKey:k_lectionName];
	PassParameter *passParameter = [[PassParameter alloc] initwithVolumnNo:m_volumnNo withLectioNo:strlectionNo 
														   withSubVolumnNo:m_subVolumnNo
														   withLectionName:lectionName];
	passParameter.m_pageIndex = [[dict valueForKey:k_pageIndex]intValue];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LECTIONDISPLAY object:passParameter];
	[passParameter release];
}

#pragma mark -
#pragma mark TableView Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *BOOK_MARK_EDIT_IDENTIFIER = @"BOOK_MARK_EDIT_IDENTIFIER";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BOOK_MARK_EDIT_IDENTIFIER];
	if (cell == nil) {
		cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
									 reuseIdentifier:BOOK_MARK_EDIT_IDENTIFIER]autorelease];
	}
	NSDictionary *dictPagemark = [self.bookMarkArray objectAtIndex: indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat: @"%@ 第%d頁"
						   ,[dictPagemark valueForKey:k_lectionName]
						   ,[[dictPagemark valueForKey:k_pageIndex]intValue] +1 ];
	cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [self.bookMarkArray count];
}

#pragma mark -
#pragma mark TableView Delegate
-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;
	[self.bookMarkArray removeObjectAtIndex:row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
					 withRowAnimation:UITableViewRowAnimationFade];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self displayBookMark:indexPath.row];
}

@end
