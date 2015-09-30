//
//  WSSessionTaskDataOperation.h
//  spending
//
//  Created by Riley Crebs on 6/23/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSAPIConstants.h"

typedef NS_ENUM(NSUInteger, WSAPIErrorCode) {
    WSAPIErrorCodeAPIError,
    WSAPIErrorCodeNotReachable
};

extern NSString * const WSAPIErrorDomain;

@protocol WSActionProtocol;

@protocol WSSessionTaskDataOperationProtocol;

@interface WSSessionTaskDataOperation : NSOperation

- (instancetype)initWithSession:(NSURLSession*)session
                         action:(id<WSActionProtocol>)action
                     completion:(WSAPICompletionBlock)completionBlock
                        failure:(WSAPIFailureBlock)failureBlock;

@property (nonatomic, weak) id<WSSessionTaskDataOperationProtocol>delegate;

@end

@protocol WSSessionTaskDataOperationProtocol <NSObject>
@required
- (void)taskDataOperation:(WSSessionTaskDataOperation*)operation
     invalidTokenOnAction:(id<WSActionProtocol>)action
               completion:(WSAPICompletionBlock)completionBlock
                  failure:(WSAPIFailureBlock)failureBlock;
- (void)validateResponseData:(NSDictionary*)data
                      action:(id<WSActionProtocol>)action
                       error:(NSError**)error;
@end