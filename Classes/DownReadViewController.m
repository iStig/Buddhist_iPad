//
//  SecondViewController.m
//  Cbeta
//
//  Created by chao he on 10-7-30.
//  Copyright Smiling  2010. All rights reserved.
//

#import "DownReadViewController.h"
#import "Utilities.h"
#import "DownFirstCatalogViewController.h"
#import "PassParameter.h"
#import "Define.h"
#import "DownSeachViewController.h"

@implementation DownReadViewController

@synthesize m_leavesView = m_leavesView;
@synthesize scrollView = _scrollView;

@synthesize m_catalogButton;
@synthesize m_titleLabel;
@synthesize m_searchButton;
@synthesize m_bookMarkButton;

@synthesize m_catalogPopoverController;
@synthesize m_searchPopoverController;
@synthesize m_bookMarkPopoverController;

@synthesize m_volumnNo;
@synthesize m_lectionNo;
@synthesize m_lectionName;
@synthesize m_subvolumnNo;



@synthesize m_isInsert;
@synthesize m_currentContent;
@synthesize m_xmlParser;

- (id)init
{
	if (self = [super init]) {
		m_leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
        m_leavesView.mode = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? LeavesViewModeSinglePage : LeavesViewModeFacingPages;
	}
	return self;
}

- (void)dealloc {
	
 	[m_catalogButton release];
	[m_titleLabel release];
	[m_searchButton release];
	[m_bookMarkButton release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:DOWN_LECTIONDISPLAY object:nil];
	[m_volumnNo release];
	[m_lectionNo release];
	[m_subvolumnNo release];
	[m_lectionName release];
	
	
	
	[m_currentContent release];
	[m_xmlParser release];
	
	[m_buttonView release];
	[m_leavesView release];
	[_scrollView release];
	CGPDFDocumentRelease(pdf);
	[m_catalogPopoverController release];
	[m_searchPopoverController release];
	[m_bookMarkPopoverController release];
	[m_catalogButton release];
	[m_titleLabel release];
    [super dealloc];
}

- (void) displayPageNumber:(NSUInteger)pageNumber {
    NSUInteger numberOfPages = CGPDFDocumentGetNumberOfPages(pdf);
    NSString *pageNumberString = [NSString stringWithFormat:@"Page %u of %u", pageNumber, numberOfPages];
    if (m_leavesView.mode == LeavesViewModeFacingPages) {
        if (pageNumber > numberOfPages) {
            pageNumberString = [NSString stringWithFormat:@"Page %u of %u", pageNumber-1, numberOfPages];
        } else if (pageNumber > 1) {
            pageNumberString = [NSString stringWithFormat:@"Pages %u-%u of %u", pageNumber - 1, pageNumber, numberOfPages];
        }
    }
	NSString *titleLable = [pageNumberString stringByAppendingFormat:@" %@",self.m_lectionName];
	m_titleLabel.text = titleLable;
}


#pragma mark -
#pragma mark Interface rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
		m_buttonView.frame =CGRectMake(0, 0, 768, 44);
		m_leavesView.mode = LeavesViewModeSinglePage;
		[self loadPortraitView];
	}else {
		m_buttonView.frame = CGRectMake(0, 0, 1024, 44);
		m_leavesView.mode = LeavesViewModeFacingPages;
		[self loadLandscapeView];
	}
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self displayPageNumber:m_leavesView.currentPageIndex + 1];
}

#pragma mark  LeavesViewDelegate methods

- (void) touchIsActiveInLeavesView:(LeavesView *)leavesView{
	[self.scrollView setMaximumZoomScale:1];
}

- (void) touchNotActiveInLeavesView:(LeavesView *)leavesView{
	[self.scrollView setMaximumZoomScale:maxSize];
}

- (void) leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex {
	[self displayPageNumber:pageIndex + 1];
}

#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return CGPDFDocumentGetNumberOfPages(pdf);
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	CGPDFPageRef page = CGPDFDocumentGetPage(pdf, index + 1);
	CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
											CGContextGetClipBoundingBox(ctx));
	
	CGContextConcatCTM(ctx, transform);
	CGContextDrawPDFPage(ctx, page);
    
    
//    CGContextDrawPDFPage (ctx, page);
//    CGContextTranslateCTM(ctx, self.view.frame.size.width/2,self.view.frame.size.height/2);
//    CGContextScaleCTM(ctx, 1, -1);
    
}

#pragma mark UIViewController

- (void) viewDidLoad {
	[super viewDidLoad];
   
    
    //增加手势 放大缩小字体
    UIPinchGestureRecognizer *twoFingerPinch =
    
    [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:nil] autorelease];
    twoFingerPinch.delegate=self;
    [[self view] addGestureRecognizer:twoFingerPinch];

    
//    CATiledLayer *tiledLayer = [CATiledLayer layer];
//    tiledLayer.delegate = self;
//    tiledLayer.tileSize = CGSizeMake(1024.0f, 1024.0f);
//    tiledLayer.levelsOfDetail = 4;
//    tiledLayer.levelsOfDetailBias = 4;
//    tiledLayer.frame = CGRectMake(0, 0, 768, 960);

    
	
	m_leavesView.frame = CGRectMake(0, 0, 768, 960);
	m_leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	m_leavesView.tag = kLeaveViewTag;
	m_leavesView.mydelegate = self;
    
   // [m_leavesView.layer addSublayer:tiledLayer];
	
	UIScrollView *scrollViewLeave = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 768, 960)];
	scrollViewLeave.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	scrollViewLeave.tag = kScrollViewTag;
	scrollViewLeave.delegate = self;
	scrollViewLeave.minimumZoomScale = 1.0;
	scrollViewLeave.maximumZoomScale = maxSize;
	scrollViewLeave.zoomScale = 1.0;
	scrollViewLeave.bouncesZoom = NO;
	scrollViewLeave.scrollEnabled = NO;
	[scrollViewLeave addSubview:m_leavesView];
	_scrollView = scrollViewLeave;
	[self.view addSubview:_scrollView];
	[scrollViewLeave release];
	
	
	m_buttonView = [[UItoolBarView alloc]initWithFrame:CGRectMake(0, 0, 768, 44)];
	[self.view addSubview:m_buttonView];
	
	self.m_catalogButton = m_buttonView._catatlogButton;
	[m_catalogButton addTarget:self action:@selector(popCatalog:) forControlEvents:UIControlEventTouchUpInside];
	
	self.m_titleLabel = m_buttonView._titleLabel;
	
	self.m_searchButton = m_buttonView._searchButton;
	[m_searchButton addTarget:self action:@selector(popSearch:) forControlEvents:UIControlEventTouchUpInside];
	
	self.m_bookMarkButton = m_buttonView.bookMarkButton;
	[m_bookMarkButton addTarget:self action:@selector(popBookMark:) forControlEvents:UIControlEventTouchUpInside];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getParameter:) name:DOWN_LECTIONDISPLAY object:nil];
	if(self.m_subvolumnNo ==nil)
	{
		self.m_volumnNo = DEFAULT_DOWN_VOLU_NO;
		self.m_lectionNo = DEFAULT_DOWN_LECTION_NO;
		self.m_lectionName = DEFAULT_DOWN_LECTION_NAME;
		self.m_subvolumnNo = DEFAULT_DOWN_SUBVOLUN_NO;
		[self LoadDefaultPdf:self.m_volumnNo and :self.m_lectionNo];
	}
	//popover catatlog
	DownFirstCatalogViewController *firstCatalogViewController = [[DownFirstCatalogViewController alloc] initWithNibName:@"DownFirstCatalogView" bundle:nil];
	UINavigationController *catalogNavigationController = [[UINavigationController alloc] initWithRootViewController:firstCatalogViewController];
	UIPopoverController *catalogPopoverController = [[UIPopoverController alloc] initWithContentViewController:catalogNavigationController];
	self.m_catalogPopoverController = catalogPopoverController;
	self.m_catalogPopoverController.delegate = self;
	[firstCatalogViewController release];
	[catalogNavigationController release];
	[catalogPopoverController release];
	
	//popover search 
	DownSeachViewController* downSearchViewController = [[DownSeachViewController alloc] initWithNibName:@"DownSearchView" bundle:nil];
	UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:downSearchViewController];
	UIPopoverController *searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:searchNavigationController];
	self.m_searchPopoverController = searchPopoverController;
	[downSearchViewController release];
	[searchPopoverController release];
	[searchNavigationController release];
	
	//popover bookmark
	DownloadBookMarkController* bookMarkViewController = [[DownloadBookMarkController alloc] init];
	
	UINavigationController *bookMarkNavigationController = [[UINavigationController alloc] initWithRootViewController:bookMarkViewController];
	UIPopoverController *bookMarkPopoverController = [[UIPopoverController alloc] initWithContentViewController:bookMarkNavigationController];
	self.m_bookMarkPopoverController = bookMarkPopoverController;
	[bookMarkViewController release];
	[bookMarkPopoverController release];
	[bookMarkNavigationController release];
	
}
#pragma mark 捏合 放大缩小字体手势
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    
}


#pragma mark gestureDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    
    if (FREE) {
        [self alert];
    }
    return YES;
}

-(void)alert{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"alertViewShowAgain"]) {
        
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"更好阅读体验，请下载大藏经完全版，点击下载"
                                                       delegate:self
                                              cancelButtonTitle:@"去下载"
                                              otherButtonTitles:@"下次不再提醒",@"取消",nil];
        [alter show];
        [alter release];
        
    }
}


#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPURL]];
        
    }else if (buttonIndex==1) {
        [[NSUserDefaults standardUserDefaults] setBool:REPEATSHOWALERTVIEW forKey:@"alertViewShowAgain"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (buttonIndex==2){
    
    }
}
-(void)viewWillAppear:(BOOL)animated
{
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		m_buttonView.frame = CGRectMake(0, 0, 1024, 44);
		m_leavesView.mode = LeavesViewModeFacingPages;
		[m_buttonView loadLandscapeView];
	}
	else {
		m_buttonView.frame =CGRectMake(0, 0, 768, 44);
		m_leavesView.mode = LeavesViewModeSinglePage;
		[m_buttonView loadPortraitView];
	}

}


-(void) getParameter:(NSNotification*)note
{
	PassParameter *passParameter = [note object];
	self.m_volumnNo = passParameter.m_volumnNo;
	self.m_lectionNo = passParameter.m_lectionNo;
	self.m_lectionName = passParameter.m_lectionName;
	self.m_subvolumnNo = passParameter.m_subVolumnNo;
	if ([self isDefaultLection:self.m_volumnNo and:self.m_lectionNo]) {
		[self LoadDefaultPdf:self.m_volumnNo and :self.m_lectionNo];
	}else {
		//读取下载的pdf文档
		[self loadPdfFromDocument];
	}
	[m_leavesView setCurrentPageIndex:passParameter.m_pageIndex];
	[self displayPageNumber:m_leavesView.currentPageIndex+1];
	[self.m_catalogPopoverController dismissPopoverAnimated:YES];
	[self.m_searchPopoverController dismissPopoverAnimated:YES];
	[self.m_bookMarkPopoverController dismissPopoverAnimated:YES];
}

#pragma mark  self Custom FUNCTION
-(NSString *)makeXml
{
	NSMutableString *xml  = [[[NSMutableString alloc]initWithString:self.m_volumnNo]autorelease] ;
	[xml appendString:@"n"];
	[xml appendString:[self addZeroToLectionNo:self.m_lectionNo]];
	[xml appendString:@".xml"];
	return xml;

}
									   
									   
-(NSString *) addZeroToLectionNo :(NSString *) oldLecNo
{
	NSMutableString *lecNo = [[[NSMutableString alloc]initWithFormat:@"%@",oldLecNo]autorelease];
	switch ([lecNo length]) {
		case  1:
			[lecNo insertString:@"000" atIndex:0];
			break;
		case 2:
			[lecNo insertString:@"00" atIndex:0];
			break;
		case 3:
			[lecNo insertString:@"0" atIndex:0];
			break;
		case 4:
		{   if([lecNo intValue]<1000)
		{
			[lecNo insertString:@"0" atIndex:0];
		}
		else {
			
		}
			break;
		}	
		default:
			break;
	}
	return lecNo;

}
									   
-(NSString *) addZeroToSubVoluNo :(NSString *) oldSubVolNo
{
	NSMutableString *SubVolNo = [[[NSMutableString alloc]initWithFormat:@"%@",oldSubVolNo]autorelease];
	switch ([SubVolNo length]) {
		case 1:
			[SubVolNo insertString:@"00" atIndex:0];
			break;
		case 2:
			[SubVolNo insertString:@"0" atIndex:0];
			break;
		case 3:
			
			break;
			
		default:
			break;
	}
	return SubVolNo;

}

  -(NSString *)getPdfPath
{
	NSArray *documentPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
	NSString *documentPath1 = ([documentPath count]>0) ? [documentPath objectAtIndex:0]:nil;
	NSString *documentPath2 =[documentPath1 stringByAppendingString:@"/"];
	NSString *documentPath3 = [documentPath2 stringByAppendingString:self.m_volumnNo]; //增加子文件夹,解压后的T01.
	NSString* paths =[documentPath3 stringByAppendingString:@"/"];
	return paths;
	
}	

-(void)LoadDefaultPdf:(NSString *)volumnNo and :(NSString *)lenctionNo
{
	CFURLRef pdfURL;
	if ([m_lectionNo isEqualToString:@"262"]) {
		pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("T09n0262.pdf"), NULL, NULL);
	}else if ([m_lectionNo isEqualToString:@"251"]) {
		pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("T08n0251.pdf"), NULL, NULL);
	}else {
		pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("T08n0235.pdf"), NULL, NULL);
	}

	pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	CFRelease(pdfURL);
	m_leavesView.dataSource = self;
	m_leavesView.mydelegate = self;
	[m_leavesView reloadData];
	m_leavesView.backgroundRendering = YES;
	[self displayPageNumber:m_leavesView.currentPageIndex+1];

}

-(void)loadPdfFromDocument
{
	NSString *paths = [self getPdfPath];
	NSString *pdfPath = [paths stringByAppendingFormat:@"%@n%@.pdf",self.m_volumnNo,[self addZeroToLectionNo:self.m_lectionNo]];
	NSLog(@"pdf path = %@",pdfPath);
    NSURL *pdfURL = [NSURL fileURLWithPath:pdfPath];
	
	pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	m_leavesView.dataSource = self;
	m_leavesView.mydelegate = self;
	[m_leavesView reloadData];
	m_leavesView.backgroundRendering = YES;
	[self displayPageNumber:m_leavesView.currentPageIndex+1];
}

-(BOOL)isDefaultLection:(NSString *)volumnNo and :(NSString *)lectionNo
{
	
	if (([volumnNo isEqualToString:@"T08"]&&[lectionNo isEqualToString:@"235"])
		||([volumnNo isEqualToString:@"T08"]&&[lectionNo isEqualToString:@"251"])
		||([volumnNo isEqualToString:@"T09"]&&[lectionNo isEqualToString:@"262"])
		) 
		return TRUE;
	else {
		return FALSE;
	}

}
-(void)popCatalog: (id)sender
{
  [self.m_catalogPopoverController presentPopoverFromRect:[m_catalogButton bounds]
												   inView:m_catalogButton  
								 permittedArrowDirections:UIPopoverArrowDirectionUp
												 animated:YES];
}

-(void)popSearch: (id)sender
{
	[self.m_searchPopoverController presentPopoverFromRect:[m_searchButton bounds]
													inView:m_searchButton
								  permittedArrowDirections:UIPopoverArrowDirectionUp
												  animated:YES];
}

-(void)popBookMark:(id)sender{
	[self.m_bookMarkPopoverController presentPopoverFromRect:[m_bookMarkButton bounds]
													  inView:m_bookMarkButton
									permittedArrowDirections:UIPopoverArrowDirectionUp
													animated:YES];
}

#pragma mark  xml parser 

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict
{
	
	if (([elementName compare:@"milestone"] == NSOrderedSame)
		&&([[attributeDict objectForKey:@"n"] intValue] == [self.m_subvolumnNo intValue])) {
		
		NSMutableString   *currentContent = [[NSMutableString alloc] initWithCapacity:0];
		self.m_currentContent = currentContent;
		[currentContent release];
		self.m_isInsert = YES;
		
	}else if (([elementName compare:@"milestone"] == NSOrderedSame)
			  &&([[attributeDict objectForKey:@"n"] intValue] >[self.m_subvolumnNo intValue])) {
		
		[parser abortParsing];
	}
	else if(([elementName compare:@"foreign"] == NSOrderedSame))
	{
		self.m_isInsert = NO;
	}
	//else if(([elementName compare:@"p"] == NSOrderedSame))
//	{
//		[self.m_currentContent appendString:@"\n"];
//	}
//	else if(([elementName compare:@"lb"] == NSOrderedSame))
//	{
//		[self.m_currentContent appendString:@"\n"];
//	}
//	else if(([elementName compare:@"l"] == NSOrderedSame))
//	{
//		[self.m_currentContent appendString:@"     "];
//		
//	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if (self.m_isInsert) {
		[self.m_currentContent appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if(([elementName compare:@"foreign"] == NSOrderedSame))
	{
		self.m_isInsert = YES;
	}else if(([elementName compare:@"body"] == NSOrderedSame)){
		
		[parser abortParsing];
	}
}

-(void)loadLandscapeView 
{
	self.scrollView.zoomScale = 1.0;
	self.scrollView.scrollEnabled = NO;
	[m_buttonView loadLandscapeView];
	[self.m_catalogPopoverController dismissPopoverAnimated:NO];
	[self.m_searchPopoverController dismissPopoverAnimated:NO];
	[self.m_bookMarkPopoverController dismissPopoverAnimated:NO];
}
-(void)loadPortraitView
{
	self.scrollView.zoomScale = 1.0;
	self.scrollView.scrollEnabled = NO;
	[m_buttonView loadPortraitView];
	[self.m_catalogPopoverController dismissPopoverAnimated:NO];
	[self.m_searchPopoverController dismissPopoverAnimated:NO];
	[self.m_bookMarkPopoverController dismissPopoverAnimated:NO];
}

#pragma mark UIScrollView delegate method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return [scrollView viewWithTag:kLeaveViewTag];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	if (scrollView.zoomScale > 1) {
		scrollView.scrollEnabled = YES;
	}else {
		scrollView.scrollEnabled = NO;
	}
	
}									   

@end
