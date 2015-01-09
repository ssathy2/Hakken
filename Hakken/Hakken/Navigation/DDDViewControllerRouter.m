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

@interface DDDViewControllerRouter ()
@property (strong, nonatomic) NSMutableDictionary *screenMapping;
@property (strong, nonatomic) UINavigationController *navigationController;
@end

@implementation DDDViewControllerRouter

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self)
    {
        self.navigationController = navigationController;
    }
    return self;
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
        id rawScreenDictionary = [rawScreenMapping valueForKey:object];
        if (![rawScreenDictionary isKindOfClass:[NSDictionary class]])
        {
            DDLogError(@"ERROR: Entry for screen: %@ is not a dictionary", object);
            continue;
        }
        screen = [[DDDScreen alloc] initWithDictionary:rawScreenDictionary];
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
    [vc setNavigationRouter:self];
    [vc prepareWithModel:attributes.model];

    // instantiate the view and replace root view if it is, if it's not then push it on
    // modal presentation takes precedence over root view
    if (attributes.presentModally)
        [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:animated completion:nil];
    else
    {
        if (screenObject.isRootView)
            [self.navigationController setViewControllers:@[vc] animated:animated];
        else
            [self.navigationController pushViewController:vc animated:animated];
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
