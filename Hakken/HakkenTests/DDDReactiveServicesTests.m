//
//  DDDReactiveServicesTests.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DDDDataServices.h"

@interface DDDReactiveServicesTests : XCTestCase
@property (strong, nonatomic) DDDDataServices *services;
@end

@implementation DDDReactiveServicesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.services = [DDDDataServices sharedInstanceWithConfiguration:@"TestConfiguration" withServicesConfiguration:@"TestServicesConfiguration"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)DISABLE_testFetchTopStories
{
    XCTestExpectation *fetchTopStories = [self expectationWithDescription:@"Fetch Top Stories"];
    __block NSArray *stories;
    RACSignal *signal = [self.services fetchTopStoriesFromStory:@(0) toStory:@(20)];
    [signal subscribeNext:^(NSArray *stories) {
        [fetchTopStories fulfill];
        stories = stories;
        if (stories)
            XCTAssert(stories.count == 20);
    } error:^(NSError *error) {
        [fetchTopStories fulfill];
        XCTAssert(error,@"ERROR in fetching top stories: %@", error);
    } completed:^{
        // idk do something here...
        [fetchTopStories fulfill];
        XCTAssert(stories.count == 20, @"Comments has count: %li", stories.count);
    }];

}

- (void)testFetchCommentsForStoryIdentifier
{
    // We've mocked a random comment json so as long as we pass some ID, we'll get back comments
    XCTestExpectation *fetchCommentsExpectation = [self expectationWithDescription:@"Fetch Comments"];

    __block NSArray *completedComments;
    RACSignal *signal = [self.services fetchCommentsForStoryIdentifier:@(1)];
    [signal subscribeNext:^(NSArray *comments) {
        completedComments = [comments copy];
        if (completedComments)
            XCTAssert(completedComments.count);
    } error:^(NSError *error) {
        [fetchCommentsExpectation fulfill];
        XCTAssert(error,@"ERROR in fetching comments: %@", error);
    } completed:^{
        [fetchCommentsExpectation fulfill];
        // idk do something here...
        XCTAssert(completedComments == nil, @"completedComments is nil!");
    }];
    [self waitForExpectationsWithTimeout:5.f handler:nil];
    XCTAssert(completedComments == nil, @"completedComments is nil!");
}

@end
