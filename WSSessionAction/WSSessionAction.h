//
//  WSSessionAction.h
//  WSSessionAction
//
//  Created by Riley Crebs on 9/30/15.
//  Copyright (c) 2015 Incravo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSActionProtocol;

typedef void (^WSAPICompletionBlock)(id response);
typedef void (^WSAPIFailureBlock)(NSError* error);
typedef void (^WSAPICancelBlock)();
typedef void (^WSAPIAuthenticateBlock)(id<WSActionProtocol> action, WSAPICompletionBlock completionBlock, WSAPIFailureBlock failureBlock);

//! Project version number for WSSessionAction.
FOUNDATION_EXPORT double WSSessionActionVersionNumber;

//! Project version string for WSSessionAction.
FOUNDATION_EXPORT const unsigned char WSSessionActionVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WSSessionAction/PublicHeader.h>
#import <WSSessionAction/WSSessionTaskDataOperation.h>
#import <WSSessionActoin/WSActionProtocol.h>

