//
//  NSMutableURLRequest+CHConnect.h
//  ChatterSDK
//
//  Created by Riley Crebs on 6/20/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (WSAPI)
/** @brief Adds header items to the request as a key value pair
 *  @param headersDictionary A dictionary of header items as a key value pair
 **/
- (void)addHeaders:(NSDictionary*) headersDictionary;

/** @brief Adds header items to the request as a key value pair
 *  @param headersDictionary A dictionary of header items as a key value pair
 **/
- (void)setHeaders:(NSDictionary*) headersDictionary;

/** @brief Add body data to the url request
 * @param data Body data to add to the URL request.
 **/
- (void)addJSONBody:(id)data;

@end
