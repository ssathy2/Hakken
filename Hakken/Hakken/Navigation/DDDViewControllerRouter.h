//
//  DDDViewControllerRouterViewController.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDTransitionAttributes, DDDViewController;

@interface DDDViewControllerRouter : NSObject

+ (instancetype)sharedInstance;

/**
 An enumeration mapping should be of the format:
 ex:
 {
 DDDExampleScreenHome : { viewClass : [DDDHomeViewController class] }
 DDDExampleScreenSettings : { viewClass : [DDDSettingsViewController class] }
 }
 Where DDDExampleScreenHome and DDDExampleScreenSettings are either enumerations or string identifiers and the value it corresponds to is a dictionary that contains the class
 */
- (void)updateScreenMapping:(NSDictionary *)screenMapping;

// The screen parameter HAS to be a screen that is part of the screen mapping
// if attributes is nil then the screen will be pushed AND the view model for the view controller will not have a model passed into it
- (void)showScreen:(id)screen usingNavigationController:(UINavigationController *)navigationController withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated;

- (void)showViewController:(DDDViewController *)viewController usingNavigationController:(UINavigationController *)navigationController withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated;
@end
