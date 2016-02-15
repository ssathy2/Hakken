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

@interface DDDViewControllerRouter ()<UISplitViewControllerDelegate>
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
    self.splitViewController.delegate = self;
}

- (UINavigationController *)splitViewControllerMasterNavigationController
{
    return [self.splitViewController.viewControllers firstObject];
}

- (UINavigationController *)splitViewControllerDetailNavigationController
{
    return self.splitViewController.viewControllers[1];
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
    DDDViewController *vc = [self viewControllerForScreen:screen];
    [self showViewControllerInMaster:vc withAttributes:attributes animated:animated];
}

- (void)showScreenInDetail:(id)screen withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    // Grab the screen from the screen mapping
    NSParameterAssert(screen);
    
    // check if the screen is a root view
    DDDViewController *vc = [self viewControllerForScreen:screen];
    [self showViewControllerInDetail:vc withAttributes:attributes animated:animated];
}

- (void)showViewControllerInDetail:(DDDViewController *)viewController withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(prepareWithModel:)])
        [viewController prepareWithModel:attributes.model];
    
    // instantiate the view and replace root view if it is, if it's not then push it on
    // modal presentation takes precedence over root view
    if (attributes.presentModally)
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self.splitViewControllerMasterNavigationController presentViewController:navController animated:YES completion:nil];
    }
    else
    {
        if (attributes.shouldBeRoot)
        {
            // TODO: what should this be?
            [self.splitViewControllerDetailNavigationController setViewControllers:@[viewController]];
        }
        else
        {
            [self.splitViewControllerDetailNavigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)showViewControllerInMaster:(DDDViewController *)viewController withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(prepareWithModel:)])
        [viewController prepareWithModel:attributes.model];
    
    // instantiate the view and replace root view if it is, if it's not then push it on
    // modal presentation takes precedence over root view
    if (attributes.presentModally)
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self.splitViewControllerMasterNavigationController presentViewController:navController animated:YES completion:nil];
    }
    else
    {
        if (attributes.shouldBeRoot)
        {
            // TODO: what should this be?
            [self.splitViewControllerMasterNavigationController setViewControllers:@[viewController]];
        }
        else
        {
            [self.splitViewControllerMasterNavigationController pushViewController:viewController animated:YES];
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
