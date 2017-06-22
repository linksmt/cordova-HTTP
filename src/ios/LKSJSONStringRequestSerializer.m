//
//  LKSJSONStringRequestSerializer.m
//  BancaCSE
//
//  Created by Matteo Polito on 5/9/17.
//
//

#import "LKSJSONStringRequestSerializer.h"

@implementation LKSJSONStringRequestSerializer

+ (instancetype)serializer {
    return [self serializerWithWritingOptions:(NSJSONWritingOptions)0];
}

+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions
{
    LKSJSONStringRequestSerializer *serializer = [[self alloc] init];
    serializer.writingOptions = writingOptions;
    
    return serializer;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
            
        }
    }];
    
    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        
        //NSLog(@"INPUT: %@", parameters);
        
        [mutableRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return mutableRequest;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    
    self.writingOptions = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(writingOptions))] unsignedIntegerValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.writingOptions forKey:NSStringFromSelector(@selector(writingOptions))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    LKSJSONStringRequestSerializer *serializer = [super copyWithZone:zone];
    serializer.writingOptions = self.writingOptions;
    
    return serializer;
}

@end
