//
//  DDDViewControllerRouterViewController.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDTransitionAttributes;

@interface DDDViewControllerRouter : NSObject

// Designated initializer
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

/**
    An enumeration mapping should be of the format:
    ex: 
        {
            DDDExampleScreenHome : { viewClass : [DDDHomeViewController class], isRootView : @(YES) }
            DDDExampleScreenSettings : { viewClass : [DDDSettingsViewController class], isRootView: @(NO) }
        }
    Where DDDExampleScreenHome and DDDExampleScreenSettings are either enumerations or string identifiers and the value it corresponds to is a dictionary that contains the class and if the view is a root view or not
 */
- (void)updateScreenMapping:(NSDictionary *)screenMapping;

// The screen parameter HAS to be a screen that is part of the screen mapping
// if attributes is nil then the screen will be pushed AND the view model for the view controller will not have a model passed into it
- (void)transitionToScreen:(id)screen withAttributes:(DDDTransitionAttributes *)attributes animated:(BOOL)animated;
@end
