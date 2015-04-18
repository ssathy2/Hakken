//
//  AppDelegate.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/17/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self configureLogging];
    [self performRealmMigrationIfNecessary];
    
    DDLogDebug(@"Realm Database Location: %@", [RLMRealm defaultRealmPath]);
    [Fabric with:@[CrashlyticsKit]];
    return YES;
}

- (void)performRealmMigrationIfNecessary
{
    // Not really sure what this does yet but since we changed the type of properties in our RLMObject subclasses, we must set a new schema version
    [RLMRealm setSchemaVersion:[[NSDate date] timeIntervalSince1970] withMigrationBlock:^(RLMMigration *migration, NSUInteger oldSchemaVersion) {
        NSInteger newVersion = [[NSDate date] timeIntervalSince1970];
        if (oldSchemaVersion > newVersion)
        {
            DDLogError(@"Old scheme version at: %@ is greater than the new schema version at: %@", @(oldSchemaVersion), @(newVersion));
        }
    }];
}

- (void)configureLogging
{
#ifdef DEBUG
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDFileLogger new]];
    
    // Enable Colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:DDLogFlagWarning];
  
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
