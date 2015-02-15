//
//  DDDBaseViewController.m
//  autolayouttest
//
//  Created by Sidd Sathyam on 02/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewController.h"

@interface DDDViewController ()
@property (strong, nonatomic) DDDViewModel *viewModel;
@end

@implementation DDDViewController
@dynamic navigationController;

#pragma mark - DDDViewControllerInstantiation
+ (instancetype)storyboardInstance
{
	NSString *storyboardName = [self storyboardName];
	UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
	return [sb instantiateViewControllerWithIdentifier:[self storyboardIdentifier]];
}

+ (NSString *)storyboardIdentifier
{
    return NSStringFromClass([self class]);
}

+ (NSString *)storyboardName
{
    return @"Main";
}

#pragma mark - DDDViewModelInstantiation

+ (Class)viewModelClass
{
    // must implement this in subclass
    return nil;
}

- (void)prepareWithModel:(id)model
{
    if (!self.viewModel)
        self.viewModel = [[[self.class viewModelClass] alloc] init];
    [self.viewModel prepareWithModel:model];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewModel viewModelDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self.viewModel viewModelWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.viewModel viewModelWillDisappear];
}

- (NSDictionary *)segueIdentifierToContainerViewControllerMapping
{
	return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[super prepareForSegue:segue sender:sender];
	NSDictionary *identifierMapping = [self segueIdentifierToContainerViewControllerMapping];
	
	if (!identifierMapping)
		return;
	
    NSString *path = [identifierMapping objectForKey:segue.identifier];
    NSAssert(path, @"This segue identifier doesn't contain a mapping! Make sure segue identifier exists in the storyboard");
    [self setValue:segue.destinationViewController forKeyPath:path];
	if ([segue.destinationViewController respondsToSelector:@selector(setViewModel:)])
		[segue.destinationViewController performSelector:@selector(setViewModel:) withObject:self.viewModel];
}
@end
