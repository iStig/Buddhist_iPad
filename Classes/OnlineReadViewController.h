//
//  FirstViewController.h
//  Cbeta
//
//  Created by chao he on 10-7-30.
//  Copyright Smiling  2010. All rights reserved.
//
//    在线阅读的经文类
#import <UIKit/UIKit.h>
#import "FirstCatalogViewController.h"
#import "LoadingIndicatorView.h"
#import"SubVolumnCatalogViewController.h"
#import "UItoolBarView.h"

@interface OnlineReadViewController : UIViewController <UIPopoverControllerDelegate,UIWebViewDelegate> {
	

	FirstCatalogViewController * m_firstCatalogViewController;
	UIPopoverController *m_catalogPopoverController;
	UIPopoverController *m_searchPopoverController;
	
	UIButton * m_catatlogButton;
	UILabel  *m_titleLabel;
	UIButton *m_searchButton;

	NSString        *m_volumnNo;     //卷号
	NSString        *m_lectionNo;    //经文号
	NSString        *m_subvolumnNo;  //分卷号
	NSString        *m_lectionName;   //经文名
	
	UIWebView       *m_webView;
	LoadingIndicatorView *m_loadingIndicator;

	UItoolBarView * m_toolView;
}

@property (nonatomic, retain) UItoolBarView * m_toolView;
@property (nonatomic, retain) FirstCatalogViewController *m_firstCatalogViewController;
@property (nonatomic, retain) UIPopoverController *m_catalogPopoverController;
@property (nonatomic ,retain) UIPopoverController *m_searchPopoverController;

@property (nonatomic, retain) UIButton *m_catalogButton;
@property (nonatomic, retain) UILabel  *m_titleLabel;
@property (nonatomic ,retain) UIButton *m_searchButton;

-(void)setHeadTitle;
-(void) popCatalog:(id)sender;
-(void) popSearch :(id)sender;

@property (nonatomic, retain) NSString *m_volumnNo;
@property (nonatomic, retain) NSString *m_lectionNo;
@property (nonatomic, retain) NSString *m_subvolumnNo;
@property (nonatomic, retain) NSString *m_lectionName;

@property (nonatomic, retain)  UIWebView   *m_webView;
@property (nonatomic, retain) LoadingIndicatorView *m_loadingIndicator;

-(NSString *) makeUrl;
-(NSString *) addZeroToLectionNo :(NSString *)oldLecNo;
-(NSString *) addZeroToSubVoluNo :(NSString *)oldSubVolNo;

-(void)getParameter:(NSNotification*) note;
-(void)loadWebPage;
@end
