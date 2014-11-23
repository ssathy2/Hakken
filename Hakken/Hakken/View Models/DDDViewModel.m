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

- (void)registerListener:(id<DDDViewModelListener>)listener
{
	if (![self.listeners containsObject:listener])
        [self.listeners addObject:listener];
}

- (void)unregisterListener:(id<DDDViewModelListener>)listener
{
	if (![self.listeners containsObject:listener])
		[self.listeners removeObject:listener];
}

- (void)notifyListenersWithSelector:(SEL)selector
{
	[self notifyListenersWithSelector:selector withObject:nil];
}

- (void)notifyListenersWithSelector:(SEL)selector withObject:(id)object1
{
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		for (id<DDDViewModelListener> listener in self.listeners)
		{
			if ([listener respondsToSelector:selector])
				[listener performSelector:selector withObject:self withObject:object1];
		}
	}];
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
