//
//  NSMutableURLRequest+WSAPITests.m
//  Pods
//
//  Created by Riley Crebs on 9/24/15.
//
//

#import <XCTest/XCTest.h>

#import "NSMutableURLRequest+WSAPI.h"

@interface NSMutableURLRequest_WSAPITests : XCTestCase
@property (nonatomic, strong) NSMutableURLRequest *request;
@end

@implementation NSMutableURLRequest_WSAPITests

- (void)setUp {
    [super setUp];
    self.request = [NSMutableURLRequest new];
}

- (void)tearDown {
    self.request = nil;
    [super tearDown];
}

- (void)testAddHeaders_WithNoPreviouslyHeadersItems_ShouldAddHeaders {
    
    XCTAssertEqual([self.request.allHTTPHeaderFields count], 0);
    NSDictionary *headerItems = @{@"KeyOne":@"ValueOne", @"KeyTwo": @"ValueTwo"};
    [self.request addHeaders:headerItems];
    NSDictionary *allHeaderField = self.request.allHTTPHeaderFields;
    XCTAssertEqual([allHeaderField count], [headerItems count]);
}

- (void)testAddHeaders_WithPreviouslyAddedHeadersItems_ShouldHaveHeadersInAddtionToAddedHeaders {
    XCTAssertEqual([self.request.allHTTPHeaderFields count], 0);
    NSDictionary *dict = @{@"KeyOne":@"ValueOne", @"KeyTwo": @"ValueTwo"};
    [self.request addHeaders:dict];
    XCTAssertEqual([self.request.allHTTPHeaderFields count], [dict count]);
    
    NSDictionary *additionalHeaders = @{@"KeyThree" :@"ValueThree", @"KeyFour":@"ValueFour"};
    [self.request addHeaders:additionalHeaders];
    XCTAssertEqual([self.request.allHTTPHeaderFields count], [dict count] + [additionalHeaders count]);
}

- (void)testSetHeaders_WithNoPreviouslyHeadersItems_ShouldAddHeaders {
    XCTAssertEqual([self.request.allHTTPHeaderFields count], 0);
    NSDictionary *headerItems = @{@"KeyOne":@"ValueOne", @"KeyTwo": @"ValueTwo"};
    [self.request setHeaders:headerItems];
    NSDictionary *allHeaderField = self.request.allHTTPHeaderFields;
    XCTAssertEqual([allHeaderField count], [headerItems count]);
}

- (void)testSetHeaders_WithHeadersItems_ShouldHaveHeadersInAddtionToAddedHeaders {
    XCTAssertEqual([self.request.allHTTPHeaderFields count], 0);
    NSDictionary *dict = @{@"KeyOne":@"ValueOne", @"KeyTwo": @"ValueTwo"};
    [self.request setHeaders:dict];
    XCTAssertEqual([self.request.allHTTPHeaderFields count], [dict count]);
    
    NSDictionary *additionalHeaders = @{@"KeyThree" :@"ValueThree", @"KeyFour":@"ValueFour"};
    [self.request setHeaders:additionalHeaders];
    XCTAssertEqual([self.request.allHTTPHeaderFields count], [dict count] + [additionalHeaders count]);
}

- (void)testAddBody_WithPreviouslyEmptyBody_ShouldAddBodyData {
    NSDictionary *dict = @{@"KeyThree" :@"ValueThree", @"KeyFour":@"ValueFour"};
    [self.request addJSONBody:dict];
    XCTAssertNotNil(self.request.HTTPBody);
}

@end
