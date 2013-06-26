    //
//  OnlineSearchViewController.m
//  cbeta
//
//  Created by chao he on 10-7-12.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "OnlineSearchViewController.h"
#import "Catalog.h"
#import "SubVolumnElement.h"
#import "SubVolumnCatalogViewController.h"

#define  NET_SEARCH_RESULT_INIT  @"網上搜索結果"  
#define  VOLU_NUMBER_INIT        @"無結果"


@implementation OnlineSearchViewController

@synthesize m_tableView;

@synthesize m_searchBar;
@synthesize m_resultLectionArray;
@synthesize m_resultVolumnNo;
@synthesize m_lectionArray;

- (void)dealloc {
	[m_tableView release];
	[m_searchBar release];
	
	[m_resultLectionArray release];
	[m_resultVolumnNo release];
	[m_lectionArray release];

    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.contentSizeForViewInPopover =  CGSizeMake(320, 500);
	
	self.m_searchBar.delegate = self;
	//self.m_searchBar.showsCancelButton = YES;
	self.m_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.m_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.m_searchBar.keyboardType = UIKeyboardTypeDefault;
	
	//网上搜索页面初始化
	NSMutableArray *tempLectionArray = [[NSMutableArray alloc]init];
	NSMutableDictionary *dicLection = [[NSMutableDictionary alloc]init];
	NSString *noResult = [NSString stringWithString:NET_SEARCH_RESULT_INIT];
	[dicLection setValue:noResult forKey:@"lection_name"];
	[tempLectionArray addObject:dicLection];
	self.m_lectionArray = tempLectionArray;       //默认经文数组
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:m_lectionArray.count];
	self.m_resultLectionArray = array;
	[array release];
	[m_resultLectionArray addObjectsFromArray:m_lectionArray];   //搜索经文数组赋值
	
	NSMutableArray *tempVoluArray = [[NSMutableArray alloc]init];
	NSString *temp=[NSString stringWithString:VOLU_NUMBER_INIT];
	[tempVoluArray addObject:temp];
	self.m_resultVolumnNo = tempVoluArray;               //默认卷号
	
	[tempLectionArray release];
	[tempVoluArray release];
	
    [super viewDidLoad];
}

-(void)handleSearchForItem:(NSString *)searchItem
{
	NSMutableArray *searchLectionResult = [[NSMutableArray alloc]init];
	NSMutableArray *searchVolumnResult = [[NSMutableArray alloc] init];
	
	
		Catalog *catalog = [Catalog sharedCatalog];
		NSArray *firstCata = [catalog topCatalog];
		for (NSDictionary *firstDic in firstCata) 
		{
			NSArray *secondCata = [firstDic valueForKey:@"catalog"];
			for (NSDictionary *secDic in secondCata ) 
			{
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
	if ([searchLectionResult count] == 0){
		
		NSMutableDictionary *dicLection = [[NSMutableDictionary alloc]init];
		NSString *noResult = [NSString stringWithString:@"沒有搜索到所要找的經文"];
		[dicLection setValue:noResult forKey:@"lection_name"];
		[searchLectionResult addObject:dicLection];
		[dicLection release];
		
		NSString *temp=[NSString stringWithString:VOLU_NUMBER_INIT];
		[searchVolumnResult addObject:temp];
		 
	}
	self.m_resultLectionArray = searchLectionResult;
	self.m_resultVolumnNo = searchVolumnResult;

	[searchLectionResult release];
	[searchVolumnResult release];

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark  tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
		return [self.m_resultLectionArray count];
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"searchResult";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell	== nil)
	{
		cell = [[[UITableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]autorelease];
	}

		NSDictionary *dict = [self.m_resultLectionArray objectAtIndex:indexPath.row];
		cell.textLabel.text = [dict valueForKey:@"lection_name"];
		cell.textLabel.font = [UIFont systemFontOfSize:16.0];

		if ([[self.m_resultVolumnNo objectAtIndex:0]isEqualToString:VOLU_NUMBER_INIT]) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}else {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
	return cell;

}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self.m_resultVolumnNo count]!= 0) {
		
			if ([[self.m_resultVolumnNo objectAtIndex:0]isEqualToString:VOLU_NUMBER_INIT]) {
				[tableView deselectRowAtIndexPath:indexPath animated:YES];	
			}else {
				NSString *fullVolumnNo =[m_resultVolumnNo objectAtIndex:indexPath.row];
				NSMutableString *volumnNo = [[NSMutableString alloc]initWithString:fullVolumnNo];
				[volumnNo deleteCharactersInRange:NSMakeRange(3, [fullVolumnNo length]-3)];
				
				NSDictionary *dict = [m_resultLectionArray objectAtIndex:indexPath.row];
				LectionCatalogElement *lectionCataElement =[[LectionCatalogElement alloc]initWithDictionary:dict];
				SubVolumnCatalogViewController *controller = [[SubVolumnCatalogViewController alloc]
															  initWithNibName:@"SubVolumnCatalogView" bundle:nil];
				controller.m_volunNo = volumnNo;
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

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	[self.m_searchBar resignFirstResponder];
//	return indexPath;
//}

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
		[m_resultLectionArray removeAllObjects];	// clear the filtered array first
		[self handleSearchForItem:searchTerm];
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
	
	[self.m_resultLectionArray removeAllObjects];
	[self.m_resultLectionArray addObjectsFromArray:self.m_lectionArray];
	[self.m_resultVolumnNo removeAllObjects];
	self.m_resultVolumnNo = tempVoluArray;   
	
	[tempVoluArray release];
    [self.m_tableView reloadData];
	 self.m_searchBar.text = @"";
    [self.m_searchBar resignFirstResponder];

}
@end
