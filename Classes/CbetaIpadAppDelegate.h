//
//  CbetaIpadAppDelegate.h
//  CbetaIpad
//
//  Created by chao he on 10-8-2.
//  Copyright Smiling  2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CbetaIpadAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate,UIAlertViewDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	NSInteger        networkingCount;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, assign) NSInteger networkingCount;

+ (CbetaIpadAppDelegate *)sharedAppDelegate;

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;
- (NSURL *)smartURLForString:(NSString *)str;
- (void)didStartNetworking;
- (void)didStopNetworking;

@end
