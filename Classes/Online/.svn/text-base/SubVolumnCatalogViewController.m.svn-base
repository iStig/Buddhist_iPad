    //
//  SubVolumnCatalogViewController.m
//  cbeta
//
//  Created by SmilingMobile on 10-6-7.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "SubVolumnCatalogViewController.h"
#import "DownloadTableCell.h"
#import "Catalog.h"
#import "SubVolumnElement.h"
#import "PassParameter.h"
#import "Define.h"

@implementation SubVolumnCatalogViewController

@synthesize m_tableView;
@synthesize m_lectionCatalogElement;
@synthesize m_subVolumn;
@synthesize m_volunNo;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.contentSizeForViewInPopover = POPOVERSIZE;
	
	UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = backItem;
	[backItem release];
	
	self.title = m_lectionCatalogElement.m_lectionName;
	
	Catalog *catalog;
	// get the catalog
	catalog = [Catalog sharedCatalog];
	self.m_subVolumn = [catalog getSubVolumn:self.m_lectionCatalogElement];
	[super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[m_lectionCatalogElement release];
	[m_tableView release];
    [m_volunNo release];
	[m_subVolumn release];
	[super dealloc];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [m_subVolumn count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"topCatalogCell";
   
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
    // Configure the cell...
    NSDictionary *dict = [self.m_subVolumn objectAtIndex:indexPath.row];
	
	SubVolumnElement *subCataElement = [[SubVolumnElement alloc] initWithDictionary:dict];
	cell.textLabel.text = subCataElement.m_subVolumnName;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[subCataElement release];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary       *dict = [self.m_subVolumn objectAtIndex:indexPath.row];
	SubVolumnElement   *suvVoluCataElement = [[SubVolumnElement alloc] initWithDictionary:dict];

	NSString *lectionNo =[[NSString alloc]initWithString:self.m_lectionCatalogElement.m_lectionNumber];
	NSString *lectionName =[[NSString alloc]initWithString:self.m_lectionCatalogElement.m_lectionName];

	
	PassParameter *passParameter = [[PassParameter alloc]initwithVolumnNo:self.m_volunNo 
														withLectioNo:lectionNo 
														withSubVolumnNo:suvVoluCataElement.m_subVolumnNo 
														  withLectionName:lectionName];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ONLINE_LECTIONDISPLAY object:passParameter];
	[passParameter release];
	
	
}


@end
