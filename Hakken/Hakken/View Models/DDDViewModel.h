//
//  DDDViewModel.h
//  autolayouttest
//
//  Created by Sidd Sathyam on 01/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

// An empty protocol declaration that inherting view models must inherit from when defining view model delegate methods
@protocol DDDViewModelListener <NSObject> @optional

@end

@interface DDDViewModel : NSObject<DDDViewModelListener>
- (void)prepareWithModel:(id)model;

- (void)registerListener:(id<DDDViewModelListener>)listener;
- (void)unregisterListener:(id<DDDViewModelListener>)listener;

- (void)notifyListenersWithSelector:(SEL)selector;
- (void)notifyListenersWithSelector:(SEL)selector withObject:(id)object;

// View Controller Lifecycle Hooks
- (void)viewModelWillAppear;
- (void)viewModelWillDisappear;
- (void)viewModelDidLoad;
- (void)viewModelDidAppear;
- (void)viewModelDidDisappear;
@end
