//
//  DDDTopStoriesViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesViewController.h"
#import "TopStoryStoryboardIdentifiers.h"
#import "DDDTopStoriesViewModel.h"
#import "DDDArrayInsertionDeletion.h"

@interface DDDTopStoriesViewController ()
@end

@implementation DDDTopStoriesViewController

+ (NSString *)storyboardName
{
    return DDDTopStoriesStoryboardName;
}

+ (NSString *)storyboardIdentifier
{
    return DDDTopStoriesViewControllerIdentifier;
}

+ (Class)viewModelClass
{
    return [DDDTopStoriesViewModel class];
}

- (DDDTopStoriesViewModel *)topStoriesViewModel
{
    return (DDDTopStoriesViewModel *)self.viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[[self topStoriesViewModel] subscribeToViewModelProperty:@keypath([self topStoriesViewModel].latestTopStoriesUpdate)]
    subscribeNext:^(DDDArrayInsertionDeletion *insertionDeletion) {
        DDLogInfo(@"X: %@", insertionDeletion);
    } error:^(NSError *error) {
        DDLogError(@"%@", error);
    } completed:^{
       
    }];
}
@end
