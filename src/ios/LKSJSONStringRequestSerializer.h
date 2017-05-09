//
//  LKSJSONStringRequestSerializer.h
//  BancaCSE
//
//  Created by Matteo Polito on 5/9/17.
//
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

@interface LKSJSONStringRequestSerializer : AFHTTPRequestSerializer

/**
 Options for writing the request JSON data from Foundation objects. For possible values, see the `NSJSONSerialization` documentation section "NSJSONWritingOptions". `0` by default.
 */
@property (nonatomic, assign) NSJSONWritingOptions writingOptions;

/**
 Creates and returns a JSON serializer with specified reading and writing options.
 
 @param writingOptions The specified JSON writing options.
 */
+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions;

@end
