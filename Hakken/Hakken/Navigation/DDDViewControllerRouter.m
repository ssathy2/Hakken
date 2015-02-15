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
@property (strong, nonatomic) NSMutableDictionary *screenMapping;
@end

@implementation DDDViewControllerRouter

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self sharedInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    [self setupNavigationController];
}

- (void)setupNavigationController
{
    self.navigationBar.barTintColor = [UIColor navigationBarBackgroundColor];
    self.navigationBar.barStyle = UIStatusBarStyleLightContent;
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

- (void)transitionToScreen:(id)screen withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated
{
    // Grab the screen from the screen mapping
    NSParameterAssert(screen);
    
    // check if the screen is a root view
    DDDScreen *screenObject = [self.screenMapping objectForKey:screen];
    DDDViewController *vc = [self viewControllerForScreen:screen];
    [vc prepareWithModel:attributes.model];

    // instantiate the view and replace root view if it is, if it's not then push it on
    // modal presentation takes precedence over root view
    if (attributes.presentModally)
    {
        DDDViewControllerRouter *router = [[DDDViewControllerRouter alloc] initWithRootViewController:vc];;
        [router updateScreenMapping:[self.screenMapping copy]];
        [self presentViewController:router animated:animated completion:nil];
    }
    else
    {
        if (screenObject.isRootView)
            [self setViewControllers:@[vc] animated:animated];
        else
            [self pushViewController:vc animated:animated];
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
