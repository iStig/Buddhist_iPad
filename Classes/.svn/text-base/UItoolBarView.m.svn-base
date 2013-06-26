//
//  UItoolBarView.m
//  CbetaIpad
//
//  Created by yywang on 10-8-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UItoolBarView.h"


@implementation UItoolBarView

@synthesize _catatlogButton;
@synthesize _titleLabel;
@synthesize _searchButton;
@synthesize bookMarkButton = _bookMarkButton;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self setBackgroundColor:[UIColor grayColor]];
		
		self._catatlogButton = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *menuPath = [[NSBundle mainBundle] pathForResource:@"menu_normal.png" ofType:nil];
		UIImage *imgMenu = [[UIImage alloc] initWithContentsOfFile:menuPath];
		NSString *menuPathHL = [[NSBundle mainBundle] pathForResource:@"menu_highlight.png" ofType:nil];
		UIImage *imgMenuHL = [[UIImage alloc] initWithContentsOfFile:menuPathHL];

		[_catatlogButton setFrame:CGRectMake(0, 0, 100, 44)];
		[_catatlogButton setImage:imgMenu forState:UIControlStateNormal];
		[_catatlogButton setImage:imgMenuHL forState:UIControlStateHighlighted];
		[self addSubview:_catatlogButton];
		[imgMenu release];
		[imgMenuHL release];
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 11, 339, 31)];
		self._titleLabel = titleLabel;
		[titleLabel release];
		[_titleLabel setBackgroundColor:[UIColor clearColor]];
		[_titleLabel setTextAlignment:UITextAlignmentCenter];
		[self addSubview:_titleLabel];
	
		self._searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *searchPath = [[NSBundle mainBundle] pathForResource:@"search_normal.png" ofType:nil];
		UIImage *imgSearch = [[UIImage alloc] initWithContentsOfFile:searchPath];
		NSString *searchHLPath = [[NSBundle mainBundle] pathForResource:@"search_highlight.png" ofType:nil];
		UIImage *imgSearchHL = [[UIImage alloc] initWithContentsOfFile:searchHLPath];
		[_searchButton setFrame:CGRectMake(668, 0, 100, 44)];
		[_searchButton setImage:imgSearch forState:UIControlStateNormal];
		[_searchButton setImage:imgSearchHL forState:UIControlStateHighlighted];
		[self addSubview:_searchButton];
		[imgSearch release];
		[imgSearchHL release];
		
		_bookMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *bookMarkPath = [[NSBundle mainBundle] pathForResource:@"bookMark_normal.png" ofType:nil];
		UIImage *imgBookMark = [[UIImage alloc] initWithContentsOfFile:bookMarkPath];
		NSString *bookMarkHLPath = [[NSBundle mainBundle] pathForResource:@"bookMark_highlight.png" ofType:nil];
		UIImage *imgBookMarkHL = [[UIImage alloc] initWithContentsOfFile:bookMarkHLPath];
		[_bookMarkButton setFrame:CGRectMake(600, 0, 71, 44)];
		[_bookMarkButton setImage:imgBookMark forState:UIControlStateNormal];
		[_bookMarkButton setImage:imgBookMarkHL forState:UIControlStateHighlighted];
		[self addSubview:_bookMarkButton];
		[imgBookMark release];
		[imgBookMarkHL release];
    }
    return self;
}

-(void)loadLandscapeView 
{
	[self setFrame:CGRectMake(0, 0, 1024, 44)];
	[self._titleLabel setFrame:CGRectMake(342, 11, 339, 31)];
	[self._searchButton setFrame:CGRectMake(924, 0, 100, 44)];
	[_bookMarkButton setFrame:CGRectMake(856, 0, 71, 44)];
}
-(void)loadPortraitView
{
	[self setFrame:CGRectMake(0, 0, 768, 44)];
	[self._titleLabel setFrame:CGRectMake(205, 11, 339, 31)];
	[self._searchButton setFrame:CGRectMake(668, 0, 100, 44)];
	[_bookMarkButton setFrame:CGRectMake(600, 0, 71, 44)];
}

- (void)dealloc {
	[_catatlogButton release];
	[_titleLabel release];
	[_searchButton release];
	[_bookMarkButton release];
    [super dealloc];
}


@end
