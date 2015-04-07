//
//  iCarouselExampleAppDelegate.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "iCarouselExampleAppDelegate.h"
#import "iCarouselExampleViewController.h"

@implementation iCarouselExampleAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [window addSubview:viewController.view];
    window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds] ];
    viewController = [[iCarouselExampleViewController alloc]init];
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
    return YES;
}


@end