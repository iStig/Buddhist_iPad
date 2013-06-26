//
//  PassParameter.h
//  CbetaIpad
//
//  Created by chao he on 10-8-3.
//  Copyright 2010 Smiling . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PassParameter : NSObject {
	NSString *m_volumnNo;
	NSString *m_lectionNo;
	NSString *m_subVolumnNo;
	NSString *m_lectionName;
	NSUInteger m_pageIndex;
}

@property (nonatomic,retain)NSString *m_volumnNo;
@property (nonatomic,retain)NSString *m_lectionNo;
@property (nonatomic,retain)NSString *m_subVolumnNo;
@property (nonatomic,retain)NSString *m_lectionName;
@property (assign)NSUInteger m_pageIndex;

-(id)initwithVolumnNo:(NSString *)volumnNo withLectioNo :(NSString *)lectionNo 
	                                       withSubVolumnNo :(NSString *)subVolumnNo 
										   withLectionName:(NSString *)lectionName;
@end
