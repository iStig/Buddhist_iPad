//
//  PassParameter.m
//  CbetaIpad
//
//  Created by chao he on 10-8-3.
//  Copyright 2010 Smiling . All rights reserved.
//

#import "PassParameter.h"


@implementation PassParameter

@synthesize m_volumnNo;
@synthesize m_lectionNo;
@synthesize m_subVolumnNo;
@synthesize m_lectionName;
@synthesize m_pageIndex;

-(id)initwithVolumnNo:(NSString *)volumnNo withLectioNo :(NSString *)lectionNo 
										 withSubVolumnNo :(NSString *)subVolumnNo 
										 withLectionName:(NSString *)lectionName
{
	self.m_volumnNo = volumnNo;
	self.m_lectionNo = lectionNo;
	self.m_subVolumnNo =subVolumnNo;
	self.m_lectionName = lectionName;
	return self;
}


-(void)dealloc
{
	[m_volumnNo release];
	[m_lectionNo release];
	[m_subVolumnNo release];
	[m_lectionName release];
    [super dealloc];

}
@end
