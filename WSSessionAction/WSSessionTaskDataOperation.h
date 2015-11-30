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

@class FXReachability;

@protocol WSActionProtocol;
@protocol WSSessionTaskDataOperationProtocol;

@interface WSSessionTaskDataOperation : NSOperation

/* Initialize with a reachability.
 @param reachability Reachability object
 @return new instance with an reachability object.
 */
- (instancetype)initWithReachability:(FXReachability*)reachability;

- (void)executeAction:(id<WSActionProtocol>)action
            inSession:(NSURLSession*)session
             delegate:(id<WSSessionTaskDataOperationProtocol>)delegate
           completion:(WSAPICompletionBlock)completionBlock
              failure:(WSAPIFailureBlock)failureBlock;

@property (nonatomic, weak) id<WSSessionTaskDataOperationProtocol>delegate;

@end

@protocol WSSessionTaskDataOperationProtocol <NSObject>
@required
/* Object conforming to this protocol is required to give the baseURL
 @return The base URL to make the request to
 */
- (NSString*)baseURL;

/* Object conforming to this protocol is required to give the scheme for the request
 @return The scheme to make the request to
 */
- (NSString*)scheme;

/* Object conforming to this protocol is responsible for handling state where network is not reachable
 @param error NSError object specifing the error associated with the network not being reachable.
 */
- (void)handleNetworkNotReachable:(NSError*)error;

@optional
/* Optionally the object confroming to this protocol can handle an invalid token by implementing this method
 @param operation Operation object that with invalid token on request
 @param action Sent action that has an invalid token
 @param completionBlock
 @param failureBlock
 */
- (void)taskDataOperation:(WSSessionTaskDataOperation*)operation
     invalidTokenOnAction:(id<WSActionProtocol>)action
               completion:(WSAPICompletionBlock)completionBlock
                  failure:(WSAPIFailureBlock)failureBlock;

/* Optionally the object conforming to this protocol can validate response data by implementing this method
 @param data The data to validate
 @param action The action under validation
 @param error Object can send assign an error to this param to pass up the stack.
 @return Return True if valid data for the action, false otherwise.
 */
- (BOOL)validateResponseData:(NSDictionary*)data
                      action:(id<WSActionProtocol>)action
                       error:(NSError**)error;

@end
