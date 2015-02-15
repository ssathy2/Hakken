//
//  DDDTopStoriesViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/9/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesViewController.h"
#import "DDDTopStoriesViewModel.h"
#import "DDDTransitionAttributes.h"
#import "TopStoryStoryboardIdentifiers.h"

@implementation DDDTopStoriesViewController
+ (Class)viewModelClass
{
    return [DDDTopStoriesViewModel class];
}

+ (NSString *)storyboardIdentifier
{
    return DDDTopStoriesViewControllerIdentifier;
}

- (IBAction)readLaterButtonTapped:(id)sender
{
    DDDTransitionAttributes *attrs = [DDDTransitionAttributes new];
    attrs.presentModally = YES;
    [self.navigationController transitionToScreen:DDDSavedStoriesViewControllerIdentifier withAttributes:attrs animated:YES];
}
@end
