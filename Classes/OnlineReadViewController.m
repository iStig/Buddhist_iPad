
//
//  Created by chao he on 10-7-30.
//  Copyright Smiling  2010. All rights reserved.
//

#import "OnlineReadViewController.h"
#import "PassParameter.h"
#import "Define.h"
#import "PassParameter.h"
#import "OnlineSearchViewController.h"

//默认加载的页面
#define DEFAULT_VOLU_NO     @"T01"
#define DEFAULT_LECTION_NO  @"1"
#define DEFAULT_LECTION_NAME @"長阿含經"
#define DEFAULT_SUBVOLUN_NO  @"1"


@implementation OnlineReadViewController

static NSString* X42_734 = @"http://www.cbeta.org/result/normal/X42/0734_009.htm";

@synthesize m_firstCatalogViewController;
@synthesize m_catalogPopoverController;
@synthesize m_searchPopoverController;

@synthesize m_catalogButton;
@synthesize m_titleLabel;
@synthesize m_searchButton;

@synthesize m_volumnNo;
@synthesize m_lectionNo;
@synthesize m_subvolumnNo;
@synthesize m_lectionName;
@synthesize m_webView;
@synthesize m_loadingIndicator;

@synthesize m_toolView;

- (void)viewDidLoad {
	
	UItoolBarView * toolView = [[UItoolBarView alloc] initWithFrame:CGRectMake(0, 0, 768, 44)];
	[toolView.bookMarkButton setHidden:YES];
	self.m_toolView = toolView;
	[toolView release];
	[self.view addSubview:self.m_toolView];
	
	self.m_catalogButton = m_toolView._catatlogButton;
	[m_catalogButton addTarget:self action:@selector(popCatalog:) forControlEvents:UIControlEventTouchUpInside];
	
	self.m_titleLabel = m_toolView._titleLabel;
	
	self.m_searchButton = m_toolView._searchButton;
	[m_searchButton addTarget:self action:@selector(popSearch:) forControlEvents:UIControlEventTouchUpInside];
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 768, 931)];
	self.m_webView = webView;
	[m_webView setDelegate:self];
	[webView release];
	[self.view addSubview:self.m_webView];
	
	LoadingIndicatorView *loadingView = [[LoadingIndicatorView alloc] initWithNibName:@"LoadingIndicatorView" bundle:nil];
	self.m_loadingIndicator = loadingView;
	[loadingView release];
	CGRect frame = CGRectMake(344, 480, 80, 60);
	m_loadingIndicator.view.frame = frame;
	[self.m_webView addSubview:m_loadingIndicator.view];
	m_loadingIndicator.view.hidden =YES;
	
	//popover catatlog
	FirstCatalogViewController *firstCatalogViewController = [[FirstCatalogViewController alloc] initWithNibName:@"FirstCatalogView" bundle:nil];
	self.m_firstCatalogViewController = firstCatalogViewController;
	UINavigationController *catalogNavigationController = [[UINavigationController alloc] initWithRootViewController:self.m_firstCatalogViewController];
	UIPopoverController *catalogPopoverController = [[UIPopoverController alloc] initWithContentViewController:catalogNavigationController];
	self.m_catalogPopoverController = catalogPopoverController;
	self.m_catalogPopoverController.delegate = self;
	
	[firstCatalogViewController release];
	[catalogNavigationController release];
	[catalogPopoverController release];
	
	//popvoer search
	OnlineSearchViewController *searchViewController = [[OnlineSearchViewController alloc] initWithNibName:@"OnlineSearchView" bundle:nil];
	UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
	UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:searchNavigationController];
	self.m_searchPopoverController = popoverController;
	self.m_searchPopoverController.delegate = self;
	[searchViewController release];
	[popoverController release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getParameter:)name:ONLINE_LECTIONDISPLAY object:nil];
	  if(self.m_subvolumnNo ==nil)
	{
		self.m_volumnNo = DEFAULT_VOLU_NO;
		self.m_lectionNo = DEFAULT_LECTION_NO;
		self.m_lectionName = DEFAULT_LECTION_NAME;
		self.m_subvolumnNo = DEFAULT_SUBVOLUN_NO;
		[self loadWebPage];
	}

    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		[self.m_toolView loadLandscapeView];
		[self.m_webView setFrame:CGRectMake(0, 44, 1024, 675)];
		m_loadingIndicator.view.frame = CGRectMake(480, 340, 80, 60);
	}
	else {
		[self.m_toolView loadPortraitView];
		[self.m_webView setFrame:CGRectMake(0, 44, 768, 931)];
		m_loadingIndicator.view.frame = CGRectMake(344, 420, 80, 60);
	}
	
}

-(void)setHeadTitle
{

		NSMutableString *sublecName =[NSMutableString stringWithString:self.m_subvolumnNo];
		[sublecName appendString:self.m_lectionName];
		self.m_titleLabel.text = sublecName;


}

-(void)getParameter:(NSNotification*) note
{
	PassParameter *passParameter = [note object];
	self.m_volumnNo = passParameter.m_volumnNo;
	self.m_lectionNo = passParameter.m_lectionNo;
	self.m_lectionName = passParameter.m_lectionName;
	self.m_subvolumnNo = passParameter.m_subVolumnNo;
	[self setHeadTitle];
	[self loadWebPage];
}

#pragma mark popover methods

-(void) popCatalog :(id)sender
{
	[self.m_catalogPopoverController presentPopoverFromRect:[self.m_catalogButton bounds] inView:self.m_catalogButton  
								   permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
-(void) popSearch :(id)sender
{
	[self.m_searchPopoverController presentPopoverFromRect:[self.m_searchButton bounds] inView:self.m_searchButton 
								  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
}

-(void)loadWebPage
{
	m_webView.delegate = self;
   
	m_loadingIndicator.view.hidden = NO;
	[m_loadingIndicator startAnimating];
	
	if ([self.m_volumnNo isEqualToString:@"X42"]&&[self.m_lectionNo isEqualToString:@"734"]) {
		
		[self.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:X42_734]]];
	}else {
		[self.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self makeUrl]]]];
	}
	
	 self.m_webView.scalesPageToFit = YES;
	[self setHeadTitle];
	[self.m_catalogPopoverController dismissPopoverAnimated:YES];
	[self.m_searchPopoverController dismissPopoverAnimated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		[self.m_toolView loadLandscapeView];
		[self.m_webView setFrame:CGRectMake(0, 44, 1024, 675)];
		m_loadingIndicator.view.frame = CGRectMake(480, 340, 80, 60);
	}
	else {
		[self.m_toolView loadPortraitView];
		[self.m_webView setFrame:CGRectMake(0, 44, 768, 931)];
		m_loadingIndicator.view.frame = CGRectMake(344, 420, 80, 60);
	}

}


- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ONLINE_LECTIONDISPLAY object:nil];
	[m_volumnNo release];
	[m_lectionNo release];
	[m_subvolumnNo release];
	[m_lectionName release];
	[m_webView release];
	[m_loadingIndicator release];
	
	[m_searchButton release];
	[m_titleLabel release];
	[m_catalogButton release];

	[m_searchPopoverController release];
	[m_catalogPopoverController release];
	[m_firstCatalogViewController release];
	[m_toolView release];
    [super dealloc];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [m_loadingIndicator stopAnimating];
//    m_loadingIndicator.view.hidden = YES;
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[m_loadingIndicator stopAnimating];
	m_loadingIndicator.view.hidden = YES;
	//[m_loadingIndicator.view removeFromSuperview];
	
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"请检查网络是否连接正确");
    
    
	//UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示信息"
//													message:@"请检查网络是否连接正确"
//												   delegate:nil
//										  cancelButtonTitle:@"ok"
//										  otherButtonTitles:nil];
//	[alter show];
//	[alter release];
	
}


#pragma mark  process methods
-(NSString *)makeUrl
{
    NSMutableString *url  = [[[NSMutableString alloc]initWithFormat: @"http://www.cbeta.org/result/normal/"]autorelease] ;
	[url appendString:self.m_volumnNo ];
	[url appendString:[self addZeroToLectionNo:self.m_lectionNo]];
    [url appendString:[self addZeroToSubVoluNo:self.m_subvolumnNo]];
	return url;
	
}


-(NSString *) addZeroToLectionNo :(NSString *) oldLecNo
{
	NSMutableString *lecNo = [[[NSMutableString alloc]initWithFormat:@"%@",oldLecNo]autorelease];
	switch ([lecNo length]) {
		case  1:
			[lecNo insertString:@"/000" atIndex:0];
			[lecNo appendString:@"_"];
			break;
		case 2:
			[lecNo insertString:@"/00" atIndex:0];
			[lecNo appendString:@"_"];
			break;
		case 3:
			[lecNo insertString:@"/0" atIndex:0];
			[lecNo appendString:@"_"];
			break;
		case 4:
		{   if([lecNo intValue]<1000)
		{
			[lecNo insertString:@"/0" atIndex:0];
		}
		else {
			[lecNo insertString:@"/" atIndex:0];
			[lecNo appendString:@"_"];
		}
			break;
		}
		case 5:
			[lecNo insertString:@"/" atIndex:0];
			break;
			
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
			[SubVolNo appendString:@".htm"];
			break;
		case 2:
			[SubVolNo insertString:@"0" atIndex:0];
			[SubVolNo appendString:@".htm"];
			break;
		case 3:
			//[SubVolNo insertString:@"_" atIndex:0];
			[SubVolNo appendString:@".htm"];
			break;
			
		default:
			break;
	}
	return SubVolNo;
	
}
@end
