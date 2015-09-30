//
//  WSActionProtocol.h
//  Pods
//
//  Created by Riley Crebs on 9/24/15.
//
//

#import <Foundation/Foundation.h>

@protocol WSActionProtocol <NSObject>

@required
- (NSString*)endpoint;
- (NSString*)httpMethodType;
- (void)postActionSuccess;
- (void)postActionFailure;

@optional
- (void)preAction;
- (NSDictionary*)params;
- (NSDictionary*)headerData;
- (id)bodyData;
@end
