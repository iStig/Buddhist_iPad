    //
//  DownSeachViewController.m
//  CbetaIpad
//
//  Created by yywang on 10-8-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownSeachViewController.h"
#import "Catalog.h"
#import "SubVolumnElement.h"
#import "DownSubVolumnCatalogViewController.h"
#import "Define.h"

#define  DOWN_SEARCH_RESULT_INIT @"本地搜索結果"
#define  VOLU_NUMBER_INIT        @"無結果"

@implementation DownSeachViewController


@synthesize m_tableView;
@synthesize m_searchBar;

@synthesize m_downResultLectionArray;
@synthesize m_downResultVolumnNo;
@synthesize m_downLectionArray;

- (void)dealloc {
	[m_tableView release];
	[m_searchBar release];
	
	[m_downResultLectionArray release];
	[m_downResultVolumnNo release];
	[m_downLectionArray release ];
	
    [super dealloc];
}

-(void)viewDidLoad
{
	self.contentSizeForViewInPopover = POPOVERSIZE;
	self.m_searchBar.delegate = self;
	self.m_searchBar.showsCancelButton = NO;
	self.m_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.m_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.m_searchBar.keyboardType = UIKeyboardTypeDefault;
	
	//本地搜索初始化
	NSMutableArray *tempLectionArray2 = [[NSMutableArray alloc]init];
	NSMutableDictionary *dicLection2 = [[NSMutableDictionary alloc]init];
	NSString *noResult2 = [NSString stringWithString:DOWN_SEARCH_RESULT_INIT];
	[dicLection2 setValue:noResult2 forKey:@"lection_name"];
	[tempLectionArray2 addObject:dicLection2];
	self.m_downLectionArray = tempLectionArray2;
	
	NSMutableArray *array2 = [[NSMutableArray alloc] initWithCapacity:m_downLectionArray.count];
	self.m_downResultLectionArray = array2;
	[array2 release];
	[m_downResultLectionArray addObjectsFromArray:m_downLectionArray];
	
	NSMutableArray *tempVoluArray2 = [[NSMutableArray alloc]init];
	NSString *temp2=[NSString stringWithString:VOLU_NUMBER_INIT];
	[tempVoluArray2 addObject:temp2];
	
	//self.m_resultLectionArray = tempLectionArray2;
	self.m_downResultVolumnNo = tempVoluArray2;
	
	[tempLectionArray2 release];
	[tempVoluArray2 release];
	
    [super viewDidLoad];
	
}

-(void)handleSearchForDownLoadItem:(NSString *)searchItem
{
	NSMutableArray *searchLectionResult = [[NSMutableArray alloc]init];
	NSMutableArray *searchVolumnResult = [[NSMutableArray alloc] init];
	
	Catalog *catalog = [Catalog sharedCatalog];
	NSArray *firstCata = [catalog topCatalog];
	for (NSDictionary *firstDic in firstCata) 
	{
		if ([[firstDic valueForKey:@"download_status"]intValue]!=0) {
			NSArray *secondCata = [firstDic valueForKey:@"catalog"];
			for (NSDictionary *secDic in secondCata ) 
			{
				if ([[secDic valueForKey:@"download_status"]intValue]!=0) {
					NSArray *lectionArray =[secDic valueForKey:@"second_catalog"];
					for (NSDictionary *lecDic in lectionArray  ) 
					{
						if ([[lecDic valueForKey:@"lection_name"] rangeOfString
							 :searchItem].location != NSNotFound) 
						{
							[searchLectionResult addObject:lecDic];
							[searchVolumnResult addObject:[secDic valueForKey:@"volumn"]];
						}
					}
				}
				
			}
			
		}
	}
	//判断默认的三部经书是否存在.
	NSMutableDictionary *T08lection235 = [[NSMutableDictionary alloc]init];
	[T08lection235 setValue:[NSNumber numberWithInt:1] forKey:@"download_status"];
	[T08lection235 setValue:[NSNumber numberWithInt:1] forKey:@"lection_amount"];
	[T08lection235 setValue:[NSString stringWithString:@"【後秦 鳩摩羅什譯】"] forKey:@"lection_author"];
	[T08lection235 setValue:[NSString stringWithString:@"般若部類般若部四"] forKey:@"lection_cata"];
	[T08lection235 setValue:[NSString stringWithString:@"金剛般若波羅蜜經"] forKey:@"lection_name"];
	[T08lection235 setValue:[NSString stringWithString:@"2009/04/15"] forKey:@"lection_updatedate"];
	[T08lection235 setValue:[NSNumber numberWithInt:235] forKey:@"lection_number"];
	
	NSMutableDictionary *T08lection251 = [[NSMutableDictionary alloc]init];
	[T08lection251 setValue:[NSNumber numberWithInt:1] forKey:@"download_status"];
	[T08lection251 setValue:[NSNumber numberWithInt:1] forKey:@"lection_amount"];
	[T08lection251 setValue:[NSString stringWithString:@"【西晉 無羅叉譯】"] forKey:@"lection_author"];
	[T08lection251 setValue:[NSString stringWithString:@"般若部類般若部四"] forKey:@"lection_cata"];
	[T08lection251 setValue:[NSString stringWithString:@"般若波羅蜜多心經"] forKey:@"lection_name"];
	[T08lection251 setValue:[NSString stringWithString:@"2009/04/15"] forKey:@"lection_updatedate"];
	[T08lection251 setValue:[NSNumber numberWithInt:251] forKey:@"lection_number"];
	
	NSMutableDictionary *T09lection262 = [[NSMutableDictionary alloc]init];
	[T09lection262 setValue:[NSNumber numberWithInt:1] forKey:@"download_status"];
	[T09lection262 setValue:[NSNumber numberWithInt:7] forKey:@"lection_amount"];
	[T09lection262 setValue:[NSString stringWithString:@"【西晉 無羅叉譯】"] forKey:@"lection_author"];
	[T09lection262 setValue:[NSString stringWithString:@"法華部類法華部全"] forKey:@"lection_cata"];
	[T09lection262 setValue:[NSString stringWithString:@"妙法蓮華經"] forKey:@"lection_name"];
	[T09lection262 setValue:[NSString stringWithString:@"2009/04/15"] forKey:@"lection_updatedate"];
	[T09lection262 setValue:[NSNumber numberWithInt:262] forKey:@"lection_number"];
	
	BOOL isNotContain235 = YES; 
	BOOL isNotContain251 = YES;
	BOOL isNotContain262 = YES;
	
	for (NSDictionary *lecResult in searchLectionResult) {
		if ([[lecResult valueForKey:@"lection_name"]isEqualToString:@"金剛般若波羅蜜經"]) {
			isNotContain235 = NO;
		}
		if ([[lecResult valueForKey:@"lection_name"]isEqualToString:@"般若波羅蜜多心經"]) {
			isNotContain235 = NO;
		}
		if ([[lecResult valueForKey:@"lection_name"]isEqualToString:@"法華部類法華部全"]) {
			isNotContain235 = NO;
		}
	}
	
	if (isNotContain235) {
		if ([[T08lection235 valueForKey:@"lection_name"] rangeOfString
			 :searchItem].location != NSNotFound) 
		{
			[searchLectionResult addObject:T08lection235];
			[searchVolumnResult addObject:[NSString stringWithString:@"T08 般若部四 (221 ~ 261 经)"]];
		}
	}
	if (isNotContain251) {
		if ([[T08lection251 valueForKey:@"lection_name"] rangeOfString
			 :searchItem].location != NSNotFound) 
		{
			[searchLectionResult addObject:T08lection251];
			[searchVolumnResult addObject:[NSString stringWithString:@"T08 般若部四 (221 ~ 261 经)"]];
		}
	}
	if (isNotContain262) {
		if ([[T09lection262 valueForKey:@"lection_name"] rangeOfString
			 :searchItem].location != NSNotFound) 
		{
			[searchLectionResult addObject:T09lection262];
			[searchVolumnResult addObject:[NSString stringWithString:@"T09 法華部全、華嚴部上 (262 ~ 278 经)"]];
		}
	}
	
	
	if ([searchLectionResult count]== 0){
		
		NSMutableDictionary *dicLection = [[NSMutableDictionary alloc]init];
		NSString *noResult = [NSString stringWithString:@"沒有搜索到縮要找的經文"];
		[dicLection setValue:noResult forKey:@"lection_name"];
		[searchLectionResult addObject:dicLection];
		[dicLection release];
		
		NSString *temp=[NSString stringWithString:VOLU_NUMBER_INIT];
		[searchVolumnResult addObject:temp];
		
	}
	self.m_downResultLectionArray = searchLectionResult;
	self.m_downResultVolumnNo = searchVolumnResult;
	
	[searchLectionResult release];
	[searchVolumnResult release];
	[T08lection235 release];
	[T08lection251 release];
	[T09lection262 release];
	
}

#pragma mark  tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
		return [self.m_downResultLectionArray count];
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"searchResult";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell	== nil)
	{
		cell = [[[UITableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]autorelease];
	}
	
		NSDictionary *dict = [self.m_downResultLectionArray objectAtIndex:indexPath.row];
		cell.textLabel.text = [dict valueForKey:@"lection_name"];
		cell.textLabel.font = [UIFont systemFontOfSize:16.0];
		if ([[self.m_downResultVolumnNo objectAtIndex:0]isEqualToString:VOLU_NUMBER_INIT]) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}else {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	return cell;
	
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self.m_downResultVolumnNo count]!= 0) {
		
			//本地下载部分 
			if ([[self.m_downResultVolumnNo objectAtIndex:0]isEqualToString:VOLU_NUMBER_INIT]) {
				[tableView deselectRowAtIndexPath:indexPath animated:YES];	
			}else {
				NSString *fullVolumnNo =[m_downResultVolumnNo objectAtIndex:indexPath.row];
				NSMutableString *volumnNo = [[NSMutableString alloc]initWithString:fullVolumnNo];
				[volumnNo deleteCharactersInRange:NSMakeRange(3, [fullVolumnNo length]-3)];
				
				NSDictionary *dict = [m_downResultLectionArray objectAtIndex:indexPath.row];
				LectionCatalogElement *lectionCataElement =[[LectionCatalogElement alloc]initWithDictionary:dict];
				DownSubVolumnCatalogViewController *controller = [[DownSubVolumnCatalogViewController alloc]
																  initWithNibName:@"DownSubVolumnCatalogView" bundle:nil];
				controller.m_volumnNo = volumnNo;
				controller.m_lectionCatalogElement = lectionCataElement;
				[self.navigationController pushViewController:controller animated:YES];
				[volumnNo release];
				[lectionCataElement release];
				[controller release];
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
			}
			
	}else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.m_searchBar resignFirstResponder];
	return indexPath;
}

#pragma mark  search bar  delegate methods
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	NSString *searchTerm = [searchBar text];
	int length = [[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length];
	if ( length == 0 )
	{
		[self searchBarCancelButtonClicked:searchBar];
	}
	else
	{
		
		[m_downResultLectionArray removeAllObjects];
		[self handleSearchForDownLoadItem:searchTerm];
		[m_tableView reloadData];
	}
	[m_searchBar resignFirstResponder];
	
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if ([searchText length] == 0) {
		[self.m_tableView reloadData];
		return;
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	NSMutableArray *tempVoluArray = [[NSMutableArray alloc]init];
	NSString *temp=[NSString stringWithString:VOLU_NUMBER_INIT];
	[tempVoluArray addObject:temp];
	
	[self.m_downResultLectionArray removeAllObjects];
	[self.m_downResultLectionArray addObjectsFromArray:self.m_downLectionArray];
	[self.m_downResultVolumnNo removeAllObjects];
	self.m_downResultVolumnNo = tempVoluArray;
	
	[tempVoluArray release];
    [self.m_tableView reloadData];
	self.m_searchBar.text = @"";
    [self.m_searchBar resignFirstResponder];
	
}

@end
