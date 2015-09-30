//
//  WSAPIConstants.h
//  spending
//
//  Created by Riley Crebs on 6/24/14.
//  Copyright (c) 2014 Riley Crebs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSActionProtocol;

typedef void (^WSAPICompletionBlock)(id response);
typedef void (^WSAPIFailureBlock)(NSError* error);
typedef void (^WSAPICancelBlock)();
typedef void (^WSAPIAuthenticateBlock)(id<WSActionProtocol> action, WSAPICompletionBlock completionBlock, WSAPIFailureBlock failureBlock);

#define BLOCK(b, ...) if (b) { b(__VA_ARGS__); }
#define BLOCK_MAIN(b, ...) if (b) { dispatch_async(dispatch_get_main_queue(), ^{ b(__VA_ARGS__);});}
