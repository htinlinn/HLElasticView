//
//  HLAppDelegate.m
//  HLElasticView
//
//  Created by Htin Linn on 2/22/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import "HLAppDelegate.h"
#import "HLTableViewController.h"

@implementation HLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    HLTableViewController *tableViewController = [[HLTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
