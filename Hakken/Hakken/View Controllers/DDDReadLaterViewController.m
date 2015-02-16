//
//  DDDReadLaterViewController.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/1/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDReadLaterViewController.h"
#import "DDDReadLaterViewModel.h"
#import "TopStoryStoryboardIdentifiers.h"

@interface DDDReadLaterViewController ()

@end

@implementation DDDReadLaterViewController

+ (Class)viewModelClass
{
    return [DDDReadLaterViewModel class];
}

+ (NSString *)storyboardIdentifier
{
    return DDDSavedStoriesViewControllerIdentifier;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonTapped:)];
}

- (void)closeButtonTapped:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
