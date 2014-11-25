//
//  DDDViewModel.m
//  autolayouttest
//
//  Created by Sidd Sathyam on 01/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"

@interface DDDViewModel()
@property (strong, nonatomic) NSHashTable *listeners;
@end

@implementation DDDViewModel
- (id)init
{
	self = [super init];
	if (self)
		self.listeners = [NSHashTable weakObjectsHashTable];
	return self;
}

- (void)prepareWithModel:(id)model
{
    // use this to setup the view model from a model
}

- (RACSignal *)subscribeToViewModelProperty:(NSString *)property
{
    if (![self respondsToSelector:NSSelectorFromString(property)])
    {
        DDLogError(@"Can't subscribe to a view model property: %@ because it doesn't exist on the view model", property);
        return nil;
    }
    
    return [self rac_signalForSelector:NSSelectorFromString(property)];
}


#pragma mark - View Controller Lifecycle Hooks
- (void)viewModelDidLoad
{
    // placeholder
}

- (void)viewModelDidAppear
{
    // placeholder
}

- (void)viewModelDidDisappear
{
    // placeholder
}

- (void)viewModelWillDisappear
{
    // placeholder
}

- (void)viewModelWillAppear
{
    // placeholder   
}
@end
