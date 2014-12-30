//
//  DDDHackerNewsItemTests.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DDDHackerNewsComment.h"
#import "DDDHelpers.h"

@interface DDDHackerNewsItemTests : XCTestCase
@end

@implementation DDDHackerNewsItemTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithDictionary
{
    // Load in mock story
    [[[[DDDHelpers dictionaryFromJSONFile:@"mock_story" async:NO] filter:^BOOL(id value) {
        return value != nil;
    }] flattenMap:^RACStream *(id value) {
        return [RACSignal return:[[DDDHackerNewsItem alloc] initWithDictionary:value]];
    }] subscribeNext:^(DDDHackerNewsItem *mockStoryItem) {
        XCTAssert(mockStoryItem.kids.count == 1, @"FAIL: Number of kids should be 1...");
        XCTAssert(mockStoryItem.type == DDDHackerNewsItemTypeStory, @"FAIL: The type of this item should be a story!");
    } error:^(NSError *error) {
        XCTAssert(error == nil, @"FAIL: %@", error);
    } completed:^{
    }];
    

    // Load in mock comment
    [[[[DDDHelpers dictionaryFromJSONFile:@"mock_comment" async:NO] filter:^BOOL(id value) {
        return value != nil;
    }] flattenMap:^RACStream *(id value) {
        return [RACSignal return:[[DDDHackerNewsComment alloc] initWithDictionary:value]];
    }] subscribeNext:^(DDDHackerNewsComment *mockCommentItem) {
        XCTAssert(mockCommentItem.kids.count == 1, @"FAIL: Number of kids should be 1...");
        XCTAssert(mockCommentItem.type == DDDHackerNewsItemTypeComment, @"FAIL: The type of this item should be a comment!");
    } error:^(NSError *error) {
        XCTAssert(error == nil, @"FAIL: %@", error);
    } completed:^{
    }];
    
    // Load in mock poll
    [[[[DDDHelpers dictionaryFromJSONFile:@"mock_poll" async:NO] filter:^BOOL(id value) {
        return value != nil;
    }] flattenMap:^RACStream *(id value) {
        return [RACSignal return:[[DDDHackerNewsItem alloc] initWithDictionary:value]];
    }] subscribeNext:^(DDDHackerNewsItem *mockPoll) {
        XCTAssert(mockPoll.parts.count == 3, @"FAIL: There should be three parts to this mock poll!");
    } error:^(NSError *error) {
        XCTAssert(error == nil, @"FAIL: %@", error);
    } completed:^{
    }];
}

@end
