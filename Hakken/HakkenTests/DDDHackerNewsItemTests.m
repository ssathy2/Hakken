//
//  DDDHackerNewsItemTests.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DDDHackerNewsItem.h"
#import "DDDMock.h"

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
    NSDictionary *mockStoryDictionary = [DDDMock dictionaryFromJSONFile:@"mock_story"];
    DDDHackerNewsItem *mockStoryItem = [[DDDHackerNewsItem alloc] initWithDictionary:mockStoryDictionary];
    XCTAssert(mockStoryItem.kids.count == 1, @"FAIL: Number of kids should be 1...");
    XCTAssert(mockStoryItem.type == DDDHackerNewsItemTypeStory, @"FAIL: The type of this item should be a story!");

    // Load in mock comment
    NSDictionary *mockCommentDictionary = [DDDMock dictionaryFromJSONFile:@"mock_comment"];
    DDDHackerNewsItem *mockCommentItem = [[DDDHackerNewsItem alloc] initWithDictionary:mockCommentDictionary];
    XCTAssert(mockCommentItem.kids.count == 1, @"FAIL: Number of kids should be 1...");
    XCTAssert(mockCommentItem.type == DDDHackerNewsItemTypeComment, @"FAIL: The type of this item should be a comment!");
    
    // Load in poll model
    NSDictionary *mockPollDictionray = [DDDMock dictionaryFromJSONFile:@"mock_poll"];
    DDDHackerNewsItem *mockPoll = [[DDDHackerNewsItem alloc] initWithDictionary:mockPollDictionray];
    XCTAssert(mockPoll.parts.count == 3, @"FAIL: There should be three parts to this mock poll!");
}

@end
