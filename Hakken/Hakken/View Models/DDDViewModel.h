//
//  DDDViewModel.h
//  autolayouttest
//
//  Created by Sidd Sathyam on 01/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDViewModel : NSObject
- (void)prepareWithModel:(id)model;

// Returns a signal that a an object can subscribe inorder to get events about onNext, completed, error, etc.
- (RACSignal *)subscribeToViewModelProperty:(NSString *)property;

// View Controller Lifecycle Hooks
- (void)viewModelWillAppear;
- (void)viewModelWillDisappear;
- (void)viewModelDidLoad;
- (void)viewModelDidAppear;
- (void)viewModelDidDisappear;
@end
