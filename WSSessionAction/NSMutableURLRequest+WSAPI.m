//
//  NSMutableURLRequest+CHConnect.m
//  ChatterSDK
//
//  Created by Riley Crebs on 6/20/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "NSMutableURLRequest+WSAPI.h"

@implementation NSMutableURLRequest (WSAPI)

- (void)addHeaders:(NSDictionary*) headersDictionary {
    [headersDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self addValue:obj forHTTPHeaderField:key];
    }];
}

- (void)setHeaders:(NSDictionary*) headersDictionary {
    [headersDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forHTTPHeaderField:key];
    }];
}

- (void)addJSONBody:(id)data {
    if (data) {
        NSError* dataError = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                           options:0
                                                             error:&dataError];
        if (!dataError) {
            [self setHTTPBody:jsonData];
        }
    }
}

@end
