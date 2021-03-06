//
//  CbetaIpadAppDelegate.m
//  CbetaIpad
//
//  Created by chao he on 10-8-2.
//  Copyright Smiling  2010. All rights reserved.
//

#import "CbetaIpadAppDelegate.h"
#import "OnlineReadViewController.h"
#import "DownReadViewController.h"

@implementation CbetaIpadAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize networkingCount;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch.
    
    // Add the tab bar controller's current view as a subview of the window
	tabBarController = [[UITabBarController alloc] init];
	OnlineReadViewController *onlineReadViewController = [[OnlineReadViewController alloc] init];
	NSString *imgOnlinePath = [[NSBundle mainBundle] pathForResource:@"online_normal.png" ofType:nil];
	UIImage *imgOnline = [[UIImage alloc] initWithContentsOfFile:imgOnlinePath];
	UITabBarItem *onlineTabBarItem = [[UITabBarItem alloc]initWithTitle:@"在線閱讀" image:imgOnline tag:0];
	onlineReadViewController.tabBarItem = onlineTabBarItem;
	[onlineTabBarItem release];
	[imgOnline release];
	
	DownReadViewController *downReadViewController = [[DownReadViewController alloc]init];
	NSString *imgMybookPath = [[NSBundle mainBundle] pathForResource:@"mybook_normal.png" ofType:nil];
	UIImage *imgMybook = [[UIImage alloc] initWithContentsOfFile:imgMybookPath];
	UITabBarItem *downTabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的經書" image:imgMybook tag:1];
	downReadViewController.tabBarItem = downTabBarItem;
	[downTabBarItem release];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:onlineReadViewController,downReadViewController,nil];
	//tabBarController.selectedIndex = 1;
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
	[onlineReadViewController release];
	[downReadViewController release];
    
    
    
    if (FREE) {
        
        //增加标识，用于判断是否是第一次启动应用...
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"launchAlertViewShowAgain"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alertViewShowAgain"];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"launchAlertViewShowAgain"]) {
            
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"大藏经完全版提供更好阅读体验，点击下载"
                                                           delegate:self
                                                  cancelButtonTitle:@"去下载"
                                                  otherButtonTitles:@"下次不再提醒",@"取消",nil];
            [alter show];
            [alter release];
        }
        
    }

    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPURL]];
        NSLog(@"%d",buttonIndex);
    }else if(buttonIndex==1){
        [[NSUserDefaults standardUserDefaults] setBool:REPEATSHOWALERTVIEW forKey:@"launchAlertViewShowAgain"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%d",buttonIndex);
    }else if(buttonIndex==2){
        NSLog(@"%d",buttonIndex);
    }
}



#pragma mark -
#pragma mark Memory management

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    NSString *  result;
	NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doucumentDirectory=[path objectAtIndex:0];
    result=[doucumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.zip", prefix]];
    assert(result != nil);
    return result;
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
	
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
				|| ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}


+ (CbetaIpadAppDelegate *)sharedAppDelegate
{
    return (CbetaIpadAppDelegate *) [UIApplication sharedApplication].delegate;
}


- (void)didStartNetworking
{
    self.networkingCount += 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didStopNetworking
{
	//assert(self.networkingCount > 0);
    self.networkingCount -= 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (self.networkingCount != 0);
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

