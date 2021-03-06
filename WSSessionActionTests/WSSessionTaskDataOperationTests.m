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

@interface WSSessionTaskDataOperationTests : XCTestCase <WSActionProtocol, WSSessionTaskDataOperationProtocol>
@property (nonatomic, strong, readonly) WSSessionTaskDataOperation *sessionOperation;
@property (nonatomic, strong, readonly) NSDictionary *mockResponse;
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

- (void)testInitWithSession_WhenInvalidData_ShouldCallFailureBlock {
    NSError *error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:@{@"data" :@"some invalid data"}
                                                   options:0
                                                     error:&error];
    _mockResponse = @{@"data": data};
    WSSessionTaskDataOperation *operation = [WSSessionTaskDataOperation new];
    [operation executeAction:self
                   inSession:(NSURLSession*)self
                    delegate:self
                  completion:^(id response) {
                      XCTAssert(@"shouldn't successed");
                  } failure:^(NSError *error) {
                      XCTAssertNotNil(error);
                      XCTAssertEqualObjects(@"MockError", error.domain);
                      XCTAssertEqualObjects(@{@"error_info": @"mock_error"}, error.userInfo);
                      XCTAssertEqual(-1, error.code);
                  }];
    XCTAssertNotNil(operation);
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

#pragma mark - WSSessionTaskDataOperationDelegate
- (NSString*)baseURL {
    return @"foo.com";
}

- (NSString*)scheme {
    return @"bar";
}

- (BOOL)validateResponseData:(NSDictionary *)data
                      action:(id<WSActionProtocol>)action
                       error:(NSError *__autoreleasing *)error {
    BOOL valid = YES;
    if ([data[@"data"] isEqualToString:@"some invalid data"]) {
        valid = NO;
        *error = [NSError errorWithDomain:@"MockError"
                                     code:-1
                                 userInfo:@{@"error_info": @"mock_error"}];
    }
    return valid;
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
