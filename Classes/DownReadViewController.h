//
//  SecondViewController.h
//  Cbeta
//   
//  Created byghon 10-7-30.
//  Copyright Smiling     2010. All rights reserved.
//  本地阅读的经文类

#import <UIKit/UIKit.h>
#import "LeavesViewController.h"
#import "LeavesView.h"
#import "UItoolBarView.h"
#import "DownloadBookMarkController.h"

#define kLeaveViewTag     200
#define kScrollViewTag	  201

@interface DownReadViewController :UIViewController <LeavesViewDataSource, LeavesViewDelegate,UIGestureRecognizerDelegate,
UIPopoverControllerDelegate,UIScrollViewDelegate> {
	
	CGPDFDocumentRef pdf;
	LeavesView *m_leavesView;
	UIScrollView *_scrollView;
	
	UItoolBarView *m_buttonView;
	UIButton *m_catalogButton;
	UILabel *m_titleLabel;
	UIButton *m_searchButton;
	UIButton *m_bookMarkButton;
	
	UIPopoverController *m_catalogPopoverController;
	UIPopoverController *m_searchPopoverController;
	UIPopoverController *m_bookMarkPopoverController;
	
	NSString        *m_volumnNo;     //卷号 T34
	NSString        *m_lectionNo;    //经文号 1718
	NSString        *m_subvolumnNo;  //分卷号 内置的pdf经文有序号，1、2、3。下载的文件是一个整体，设置为1
	NSString        *m_lectionName;   //经文名 妙法蓮華經文句

	BOOL           m_isInsert;       //确定是否添加
	NSMutableString *m_currentContent;//解析中用到的取出当前内容.
	NSXMLParser *m_xmlParser;
    
}
@property (nonatomic, retain) LeavesView *m_leavesView;
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic ,retain) UIButton *m_catalogButton;
@property (nonatomic ,retain) UILabel *m_titleLabel;
@property (nonatomic ,retain) UIButton *m_searchButton;
@property (nonatomic ,retain) UIButton *m_bookMarkButton;

@property (nonatomic,retain) UIPopoverController *m_catalogPopoverController;
@property (nonatomic,retain) UIPopoverController *m_searchPopoverController;
@property (nonatomic,retain) UIPopoverController *m_bookMarkPopoverController;

@property (nonatomic, retain) NSString *m_volumnNo;
@property (nonatomic, retain) NSString *m_lectionNo;
@property (nonatomic, retain) NSString *m_subvolumnNo;
@property (nonatomic, retain) NSString *m_lectionName;


@property (nonatomic,assign) BOOL           m_isInsert;
@property (nonatomic,retain) NSMutableString *m_currentContent;
@property (nonatomic, retain) NSXMLParser    *m_xmlParser;


-(void)popCatalog: (id)sender;
-(void)popSearch: (id)sender;
-(void)popBookMark:(id)sender;
-(BOOL)isDefaultLection:(NSString *)volumnNo and :(NSString *)lectionNo;
-(NSString *)getPdfPath;
-(void)LoadDefaultPdf:(NSString *)volumnNo and :(NSString *)lenctionNo;
-(void)loadPdfFromDocument;
-(NSString *) addZeroToLectionNo :(NSString *) oldLecNo;

-(void)loadLandscapeView;
-(void)loadPortraitView;
@end
