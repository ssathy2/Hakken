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
#import "UINavigationBar+Styling.h"

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

- (void)showScreen:(id)screen usingNavigationController:(UINavigationController *)navigationController withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    // Grab the screen from the screen mapping
    NSParameterAssert(screen);
    
    // check if the screen is a root view
    DDDViewController *vc = [self viewControllerForScreen:screen];
    if (attributes.presentModally)
        [self presentViewController:vc onNavigationController:navigationController withAttributes:attributes animated:animated];
    else
        [self pushViewController:vc onNavigationController:navigationController withAttributes:attributes animated:animated];
}

- (void)pushViewController:(DDDViewController *)viewController onNavigationController:(UINavigationController *)navigationController withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(prepareWithModel:)])
        [viewController prepareWithModel:attributes.model];
    
    [navigationController pushViewController:viewController animated:animated];
}

- (void)presentViewController:(DDDViewController *)viewController onNavigationController:(UINavigationController *)navigationController withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(prepareWithModel:)])
        [viewController prepareWithModel:attributes.model];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navigationController presentViewController:navController animated:animated completion:nil];
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
