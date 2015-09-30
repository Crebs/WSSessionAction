//
//  WSSessionTaskDataOperation.m
//  spending
//
//  Created by Riley Crebs on 6/23/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import "WSSessionTaskDataOperation.h"

#import "WSActionProtocol.h"
#import "NSMutableURLRequest+WSAPI.h"

//#import <FXReachability/FXReachability.h>

#define kPoductionBaseURL @"api.wellspentapp.com"
#define kPoductionScheme @"https"

static NSInteger const kDefaultTimeOut = 3 * 60; //3 minutes

NSString * const WSAPIErrorDomain = @"WSAPIErrorDomain";



@implementation WSSessionTaskDataOperation

- (NSMutableURLRequest *)requestForAction:(id<WSActionProtocol>)action {
    // Create Request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[self urlFromAction:action] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kDefaultTimeOut];
    [request setTimeoutInterval:60.0f];
    [request setHTTPMethod:action.httpMethodType];
    
    if ([action respondsToSelector:@selector(headerData)]) {
        [request addHeaders:action.headerData];
    }
    
    if ([action respondsToSelector:@selector(bodyData)]) {
        [request addJSONBody:action.bodyData];
    }
    
    return request;
}

- (instancetype)initWithSession:(NSURLSession*)session
                         action:(id<WSActionProtocol>)action
                     completion:(WSAPICompletionBlock)completionBlock
                        failure:(WSAPIFailureBlock)failureBlock {
    if (self = [super init]) {
        // Create session task
        NSURLSessionDataTask* task = [session dataTaskWithRequest:[self requestForAction:action]
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [action postActionFailure];
                BLOCK(failureBlock, error);
            } else {
                [self handleResponseData:data
                                  action:action
                              completion:completionBlock
                                 failure:failureBlock];
            }
        }];
        [task resume];
    }
    return self;
}

- (void)handleResponseData:(id)data
                    action:(id<WSActionProtocol>)action
                completion:(WSAPICompletionBlock)completionBlock
                   failure:(WSAPIFailureBlock)failureBlock {
    NSError* serializerError = nil;
    NSDictionary *dict = [self JSONfromResponseData:data
                                              error:&serializerError];
    if (serializerError) {
        [action postActionFailure];
        BLOCK(failureBlock, serializerError);
    } else if (dict){
        NSError* error = nil;
        BOOL valid = [self isValidResponseData:dict
                                         action:action
                                          error:&error];
        if (valid) {
            [action postActionSuccess];
            BLOCK(completionBlock, dict);
        } else {
            [action postActionFailure];
            BLOCK(failureBlock, error);
        }
    }
}

- (BOOL)isValidResponseData:(NSDictionary*)dict
                      action:(id<WSActionProtocol>)action
                      error:(NSError *__autoreleasing *)error{
    [self.delegate validateResponseData:dict
                                 action:action
                                  error:error];
    return *error == nil;
}

- (NSDictionary*)JSONfromResponseData:(NSData*)data
                                error:(NSError **)error {
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:error];
    return json;
}

- (NSURL*)urlFromAction:(id<WSActionProtocol>)action {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:/%@/%@", kPoductionScheme, kPoductionBaseURL, action.endpoint]];
    return url;
}
@end
