//
//  DDDViewControllerRouterViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewControllerRouter.h"
#import "DDDViewController.h"
#import "DDDScreen.h"
#import "DDDTransitionAttributes.h"
#import "UIColor+DDDAdditions.h"

@interface DDDViewControllerRouter ()
@property (weak, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) NSMutableDictionary *screenMapping;
@end

@implementation DDDViewControllerRouter
+ (instancetype) sharedInstance
{
    static DDDViewControllerRouter* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // do any init for the shared instance here
    });
    return sharedInstance;
}

- (void)setupWithSplitViewController:(UISplitViewController *)splitViewController
{
    self.splitViewController = splitViewController;
}

- (void)updateScreenMapping:(NSDictionary *)screenMapping
{
    if (!self.screenMapping)
        self.screenMapping = [NSMutableDictionary dictionary];
    [self serializeScreenMapping:screenMapping];
}

- (void)serializeScreenMapping:(NSDictionary *)rawScreenMapping
{
    for (id object in rawScreenMapping)
    {
        DDDScreen *screen = [self.screenMapping objectForKey:object];
        id screenValue = [rawScreenMapping valueForKey:object];
        if (![screenValue isKindOfClass:[NSDictionary class]] && ![screenValue isKindOfClass:[DDDScreen class]])
        {
            DDLogError(@"ERROR: Entry for screen: %@ is not a dictionary or DDDSreen ", object);
            continue;
        }
        
        if ([screenValue isKindOfClass:[NSDictionary class]])
            screen = [[DDDScreen alloc] initWithDictionary:screenValue];
        
        if (screen == nil)
            screen = screenValue;
        
        [self.screenMapping setObject:screen forKey:object];
    }
}

- (void)showScreenInMaster:(id)screen withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    // Grab the screen from the screen mapping
    NSParameterAssert(screen);
    
    // check if the screen is a root view
    DDDScreen *screenObject = [self.screenMapping objectForKey:screen];
    DDDViewController *vc = [self viewControllerForScreen:screen];
    
    if ([vc respondsToSelector:@selector(prepareWithModel:)])
        [vc prepareWithModel:attributes.model];

    // instantiate the view and replace root view if it is, if it's not then push it on
    // modal presentation takes precedence over root view
    if (attributes.presentModally)
    {
        UINavigationController *router = [[UINavigationController alloc] initWithRootViewController:vc];
//        [router updateScreenMapping:[self.screenMapping copy]];
        [self.splitViewController showViewController:router sender:self.splitViewController];
    }
    else
    {
        if (screenObject.isRootView)
        {
            [self.splitViewController setViewControllers:@[vc]];
        }
        else
        {
            [self.splitViewController showViewController:vc sender:self.splitViewController];
        }
    }
}

- (void)showScreenInDetail:(id)screen withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    // Grab the screen from the screen mapping
    NSParameterAssert(screen);
    
    // check if the screen is a root view
    DDDScreen *screenObject = [self.screenMapping objectForKey:screen];
    DDDViewController *vc = [self viewControllerForScreen:screen];
    
    if ([vc respondsToSelector:@selector(prepareWithModel:)])
        [vc prepareWithModel:attributes.model];
    
    // instantiate the view and replace root view if it is, if it's not then push it on
    // modal presentation takes precedence over root view
    if (attributes.presentModally)
    {
        UINavigationController *router = [[UINavigationController alloc] initWithRootViewController:vc];
        //        [router updateScreenMapping:[self.screenMapping copy]];
        [self.splitViewController showViewController:router sender:self.splitViewController];
    }
    else
    {
        if (screenObject.isRootView)
        {
            // TODO: what should this be?
            [self.splitViewController setViewControllers:@[vc]];
        }
        else
        {
            [self.splitViewController showDetailViewController:vc sender:self.splitViewController];
        }
    }
}

// Either instantiate a view from storyboard or from a nib
- (id)viewControllerForScreen:(id)screen
{
    DDDScreen *screenObject = [self.screenMapping objectForKey:screen];
    Class viewClass = screenObject.viewClass;
    if ([viewClass respondsToSelector:@selector(storyboardInstance)])
        return [viewClass storyboardInstance];
    else
        return [[viewClass alloc] initWithNibName:nil bundle:nil];
        
}
@end
