    //
//  DownLectionCatalogViewController.m
//  cbeta
//
//  Created by SmilingMobile on 10-6-18.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "DownLectionCatalogViewController.h"
#import "Catalog.h"
#import "DownloadTableCell.h"
#import "Define.h"
#import "PassParameter.h"
#import "SubVolumnElement.h"

@implementation DownLectionCatalogViewController

@synthesize m_downLectionCatalogArray;
@synthesize m_volumnCatalogElement;
@synthesize m_tableView;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.contentSizeForViewInPopover = POPOVERSIZE;
	NSArray * array =[m_volumnCatalogElement.m_chapOrVolu componentsSeparatedByString:@"("];
	if ([array count]==0) {
		self.title = m_volumnCatalogElement.m_chapOrVolu;
	}else {
		self.title = [array objectAtIndex:0];
	}
	
	UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = backItem;
	[backItem release];
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated;{
	
	Catalog *catalog;
	// get the catalog
	catalog = [Catalog sharedCatalog];
	NSString *volumnName = [[NSString alloc] initWithString: self.m_volumnCatalogElement.m_chapOrVolu];
	NSMutableArray *lectionCatalogArray = [[NSMutableArray alloc]initWithArray: self.m_volumnCatalogElement.m_catalog];
	self.m_downLectionCatalogArray = lectionCatalogArray;
	
	[volumnName release];
	[lectionCatalogArray release];
    
	[m_tableView reloadData];
	
}

- (void)dealloc {
	
	[m_downLectionCatalogArray release];
	[m_volumnCatalogElement release];
	[m_tableView release];
	
	
	[super dealloc];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [m_downLectionCatalogArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"topCatalogCell";
    
	DownloadTableCell *cell = (DownloadTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DownloadTableCell" owner:self 
														   options:nil];
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (DownloadTableCell *) currentObject;
				break;
			}
		}
		
	}
    // Configure the cell...
    NSDictionary *dict = [m_downLectionCatalogArray objectAtIndex:indexPath.row];
	LectionCatalogElement *lectionCataElement = [[LectionCatalogElement alloc] initWithDictionary:dict];
	cell.m_info.text =  lectionCataElement.m_lectionName;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[lectionCataElement release];
    return cell;
}

/*
 //去掉一层目录之前的代码
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dict = [m_downLectionCatalogArray objectAtIndex:indexPath.row];
	LectionCatalogElement *lectionCataElement = [[LectionCatalogElement alloc]initWithDictionary:dict];
	DownSubVolumnCatalogViewController *controller = [[DownSubVolumnCatalogViewController alloc] 
												  initWithNibName:@"DownSubVolumnCatalogView" bundle:nil];
	controller.m_volumnNo =[self calculateTotalVolumnNo:self.m_volumnCatalogElement];
	controller.m_lectionCatalogElement = lectionCataElement;
	[self.navigationController pushViewController:controller animated:YES];
	[lectionCataElement release];
	[controller release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	LectionCatalogElement *m_lectionCatalogElement; //保存上级菜单传递过来的参数,包含经文号
	NSArray               *m_downSubVolumn;             //保存分卷情况的数组，包括分卷名字，编号，下载情况
	NSString              *m_volumnNo;               //保存级菜单传过来的卷号，如 T01,T02
	
	NSDictionary *subVolumnDict = [self.m_downLectionCatalogArray objectAtIndex:indexPath.row];
	m_lectionCatalogElement = [[LectionCatalogElement alloc]initWithDictionary:subVolumnDict];
	m_volumnNo =[self calculateTotalVolumnNo:self.m_volumnCatalogElement];
	
	Catalog *catalog = [Catalog sharedCatalog];
	m_downSubVolumn = [catalog getSubVolumn:m_lectionCatalogElement];
	
	
	
	NSDictionary       *dict = [m_downSubVolumn objectAtIndex:0];
	SubVolumnElement   *subVoluCataElement = [[SubVolumnElement alloc] initWithDictionary:dict];
	
	NSString *lectionName =[[NSString alloc]initWithString:m_lectionCatalogElement.m_lectionName];
	NSString *strlectionNo;//改变后的经书编号
	
	//用于保存要改变经书编号的字符串
	NSMutableString *tmplectionNo = [NSMutableString stringWithString:m_lectionCatalogElement.m_lectionNumber];
	if ([m_volumnNo isEqualToString:@"T05"]) 
	{	
		[tmplectionNo appendString:@"a"];
	} else if ([m_volumnNo isEqualToString:@"T06"])
	{
		[tmplectionNo appendString:@"b"];
	} else if ([m_volumnNo isEqualToString:@"T07"]) 
	{
		NSMutableString *strsubVoluNo = [NSMutableString stringWithString:subVoluCataElement.m_subVolumnNo];
		NSInteger intSubNO =[strsubVoluNo intValue];
		if (intSubNO<400) {
		}
		else if (intSubNO <= 537) {
			[tmplectionNo appendString:@"c"];
		}else if (intSubNO <= 565) {
			[tmplectionNo appendString:@"d"];
		}else if (intSubNO <= 573) {
			[tmplectionNo appendString:@"e"];
		}else if (intSubNO <= 575) {
			[tmplectionNo appendString:@"f"];
		}else if (intSubNO == 576) {
			[tmplectionNo appendString:@"g"];
		}else if (intSubNO == 577) {
			[tmplectionNo appendString:@"h"];
		}else if (intSubNO == 578) {
			[tmplectionNo appendString:@"i"];
		}else if (intSubNO <= 583) {
			[tmplectionNo appendString:@"j"];
		}else if (intSubNO <= 588) {
			[tmplectionNo appendString:@"k"];
		}else if (intSubNO == 589) {
			[tmplectionNo appendString:@"l"];
		}else if (intSubNO == 590) {
			[tmplectionNo appendString:@"m"];
		}else if (intSubNO <= 592) {
			[tmplectionNo appendString:@"n"];
		}else if (intSubNO <= 600) {
			[tmplectionNo appendString:@"o"];
		}else  {
		}
	}
	else {
		
	}
	strlectionNo =[NSString stringWithFormat:@"%@", tmplectionNo];
	
	PassParameter *passParameter = [[PassParameter alloc] initwithVolumnNo:m_volumnNo withLectioNo:strlectionNo 
														   withSubVolumnNo:subVoluCataElement.m_subVolumnNo
														   withLectionName:lectionName];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:DOWN_LECTIONDISPLAY object:passParameter];
	
	[m_lectionCatalogElement release];
	
	[subVoluCataElement release];
	[lectionName release];
	[passParameter release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
}

-(NSString *) calculateTotalVolumnNo :(CatalogElement *)voluCateElement
{
    NSMutableString *volumnNo = [[[NSMutableString alloc]initWithString:voluCateElement.m_chapOrVolu]autorelease];
	[volumnNo deleteCharactersInRange:NSMakeRange(3, [voluCateElement.m_chapOrVolu length]-3)];
	return volumnNo;
}


@end
