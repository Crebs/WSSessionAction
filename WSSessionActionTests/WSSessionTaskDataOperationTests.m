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

@interface WSSessionTaskDataOperationTests : XCTestCase <WSActionProtocol>
@property (nonatomic, strong, readonly) WSSessionTaskDataOperation *sessionOperation;
@property (nonatomic, strong, readonly) NSDictionary *mockResponse;
@end

@implementation WSSessionTaskDataOperationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
    WSSessionTaskDataOperation *operation = [[WSSessionTaskDataOperation alloc] initWithSession:(NSURLSession*)self
                                                                                         action:self
                                                                                     completion:^(id response) {
        successCompletion = YES;
    } failure:^(NSError *error) {
        XCTAssertNil(error);
    }];
    XCTAssertTrue(successCompletion);
}

- (void)testInitWithSession_WhenRequestResponseDataIsNotJSON_ShouldCallFailureBlock {
    _mockResponse = @{@"data": [@"<html>data here</html>" dataUsingEncoding:NSUTF8StringEncoding]};
    __block BOOL errorComplete = NO;
    WSSessionTaskDataOperation *operation = [[WSSessionTaskDataOperation alloc] initWithSession:(NSURLSession*)self
                                                                                         action:self
                                                                                     completion:^(id response) {
                                                                                         XCTAssertFalse(true);
                                                                                     } failure:^(NSError *error) {
                                                                                         errorComplete = YES;
                                                                                         XCTAssertNotNil(error);
                                                                                     }];
    XCTAssertTrue(errorComplete);
}

- (void)testInitWithSession_WhenRequestFailure_ShouldCallFailureBlock {
    _mockResponse = @{@"data": [NSNull null]};
    __block BOOL errorComplete = NO;
    WSSessionTaskDataOperation *operation = [[WSSessionTaskDataOperation alloc] initWithSession:(NSURLSession*)self
                                                                                         action:self
                                                                                     completion:^(id response) {
                                                                                         XCTAssertFalse(true);
                                                                                     } failure:^(NSError *error) {
                                                                                         errorComplete = YES;
                                                                                         XCTAssertNotNil(error);
                                                                                         XCTAssertEqualObjects(error.domain, @"MockDomain");
                                                                                     }];
    XCTAssertTrue(errorComplete);
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
