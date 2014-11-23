//
//  DDDBaseViewController.h
//  autolayouttest
//
//  Created by Sidd Sathyam on 02/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDViewModel;
@class DDDViewControllerRouter;

@protocol DDDViewControllerInstantiation <NSObject>
@required
// Subclassers should implement this if the path to this viewcontroller is not that that can be found by the system
+ (instancetype)storyboardInstance;

// The name of the storyboard this view controller is in. Uses "Main.storyboard" by default if this is not implemented
+ (NSString *)storyboardName;

// the identifier of the viewcontroller in the storyboard or nib within the storyboard. Uses the name of the class as default if not implemented.
+ (NSString *)storyboardIdentifier;
@end

@protocol DDDViewModelInstantiation <NSObject>
@required
// subclassers should implement this method to specify the view model that gets instantiated for this view controller
+ (Class)viewModelClass;

- (void)prepareWithModel:(id)model;
@end

@interface DDDViewController : UIViewController<DDDViewControllerInstantiation, DDDViewModelInstantiation>
@property (strong, nonatomic, readonly) DDDViewModel *viewModel;

// Subclasses implement this method to be able to bind properties of classes to resulting destination vc's of segues
- (NSDictionary *)segueIdentifierToContainerViewControllerMapping;
@end
