//
//  WSSessionTaskDataOperationTests.m
//  WSSessionTask
//
//  Created by Riley Crebs on 9/30/15.
//  Copyright (c) 2015 Riley Crebs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WSSessionTaskDataOperation.h"
#import "WSActionProtocol.h"

#import <WSFXReachability/WSFXReachability.h>
#import <OCMock/OCMock.h>

@interface WSSessionTaskDataOperationTests : XCTestCase <WSActionProtocol, WSSessionTaskDataOperationProtocol>
@property (nonatomic, strong, readonly) WSSessionTaskDataOperation *sessionOperation;
@property (nonatomic, strong, readonly) NSDictionary *mockResponse;
@property (nonatomic, assign) BOOL networkNotReachableCalled;
@property (nonatomic, assign) BOOL networkReachShouldbeCalled;
@end

@implementation WSSessionTaskDataOperationTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    _mockResponse = nil;
    [super tearDown];
}

- (void)testInitWithSession_WhenRequestSuccessful_ShouldCallCompletionBlock {
    NSError *error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:@{@"numbers" :@[@1, @2]}
                                                   options:0
                                                     error:&error];
    _mockResponse = @{@"data": data};
    __block BOOL successCompletion = NO;
    WSSessionTaskDataOperation *operation = [WSSessionTaskDataOperation new];
    [operation executeAction:self
                   inSession:(NSURLSession*)self
                    delegate:self
                  completion:^(id response) {
                      successCompletion = YES;
                  } failure:^(NSError *error) {
                      XCTAssertNil(error);
                  }];
    XCTAssertNotNil(operation);
    XCTAssertTrue(successCompletion);
}

- (void)testInitWithSession_WhenRequestResponseDataIsNotJSON_ShouldCallFailureBlock {
    _mockResponse = @{@"data": [@"<html>data here</html>" dataUsingEncoding:NSUTF8StringEncoding]};
    __block BOOL errorComplete = NO;
    WSSessionTaskDataOperation *operation = [WSSessionTaskDataOperation new];
    [operation executeAction:self
                   inSession:(NSURLSession*)self
                    delegate:self
                  completion:^(id response) {
        XCTAssertFalse(true);
    } failure:^(NSError *error) {
        errorComplete = YES;
        XCTAssertNotNil(error);
    }];
    XCTAssertNotNil(operation);
    XCTAssertTrue(errorComplete);
}

- (void)testInitWithSession_WhenRequestFailure_ShouldCallFailureBlock {
    _mockResponse = @{@"data": [NSNull null]};
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(@selector(testInitWithSession_WhenRequestFailure_ShouldCallFailureBlock))];
    WSSessionTaskDataOperation *operation = [WSSessionTaskDataOperation new];
    [operation executeAction:self
                   inSession:(NSURLSession*)self
                    delegate:self
                  completion:^(id response) {
        XCTAssertFalse(true);
    } failure:^(NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, @"MockDomain");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testTaskDataOperation_WithNoReachability_ShouldCallFailureBlock {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(@selector(testTaskDataOperation_WithNoReachability_ShouldCallFailureBlock))];
    self.networkReachShouldbeCalled = YES;
    FXReachability *reachability = [FXReachability new];
    id mockReachability = [OCMockObject partialMockForObject:reachability];
    [[[mockReachability stub] andReturnValue:OCMOCK_VALUE(NO)] isReachable];
    WSSessionTaskDataOperation *operation = [[WSSessionTaskDataOperation alloc] initWithReachability:mockReachability];
    [operation executeAction:self
                   inSession:(NSURLSession*)self
                    delegate:self
                  completion:^(id response) {
                      XCTAssertFalse(true);
                  } failure:^(NSError *error) {
                      XCTAssertNotNil(error);
                      XCTAssertEqual(WSAPIErrorCodeNotReachable, [error code]);
                      XCTAssertEqualObjects(WSAPIErrorDomain, [error domain]);
                      XCTAssertTrue(self.networkNotReachableCalled);
                      [expectation fulfill];
                  }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
    
}

#pragma mark - WSSessionTaskDataOperationDelegate 
- (NSString*)baseURL {
    return @"foo.com";
}

- (NSString*)scheme {
    return @"bar";
}

- (void)handleNetworkNotReachable:(NSError*)reachable {
    if (self.networkReachShouldbeCalled == NO) {
        XCTAssert(@"network not reachable shouldn't be called");
    } else {
        self.networkNotReachableCalled = YES;
    }
    
}
#pragma mark - Helper
- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    NSError *error;
    NSData *data = self.mockResponse[@"data"];
    if ([self.mockResponse[@"data"] isEqual:[NSNull null]]) {
        error = [NSError errorWithDomain:@"MockDomain" code:404 userInfo:@{@"mock":@"info"}];
    }
    BLOCK(completionHandler, data, [NSURLResponse new], error);
    return self;
}

- (NSString*)endpoint {
    return @"";
}
- (NSString*)httpMethodType {
    return @"";
}

- (void)postActionSuccess {
    
}

- (void)postActionFailure {
    
}

- (void)resume {
    
}
@end
