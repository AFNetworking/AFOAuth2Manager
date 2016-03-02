// AFHTTPRequestOperationManager+Synchronous.m
//
// Copyright (c) 2013 Paul Melnikow and other contributors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPRequestOperationManager+Synchronous.h"
#import "AFNetworking.h"

@implementation AFHTTPRequestOperationManager (Synchronous)

- (id)synchronouslyPerformMethod:(NSString *)method
                       URLString:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                       operation:(AFHTTPRequestOperation *__autoreleasing *)operationPtr
                           error:(NSError *__autoreleasing *)outError {

    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    AFHTTPRequestOperation *op = [self HTTPRequestOperationWithRequest:request
                                                               success:nil
                                                               failure:nil];
    
    [op start];
    [op waitUntilFinished];
    
    if (operationPtr != nil) *operationPtr = op;
    
    // Must call responseObject before checking the error
    id responseObject = [op responseObject];
    if (outError != nil) *outError = [op error];
    
    return responseObject;
}

- (id)syncGET:(NSString *)URLString
   parameters:(NSDictionary *)parameters
    operation:(AFHTTPRequestOperation *__autoreleasing *)operationPtr
        error:(NSError *__autoreleasing *)outError
{
    return [self synchronouslyPerformMethod:@"GET" URLString:URLString parameters:parameters operation:operationPtr error:outError];
}

- (id)syncPOST:(NSString *)URLString
    parameters:(NSDictionary *)parameters
     operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
         error:(NSError *__autoreleasing *) outError
{
    return [self synchronouslyPerformMethod:@"POST" URLString:URLString parameters:parameters operation:operationPtr error:outError];
}

- (id)syncPUT:(NSString *)URLString
   parameters:(NSDictionary *)parameters
    operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
        error:(NSError *__autoreleasing *) outError
{
    return [self synchronouslyPerformMethod:@"PUT" URLString:URLString parameters:parameters operation:operationPtr error:outError];
}

- (id)syncDELETE:(NSString *)URLString
      parameters:(NSDictionary *)parameters
       operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
           error:(NSError *__autoreleasing *) outError
{
    return [self synchronouslyPerformMethod:@"DELETE" URLString:URLString parameters:parameters operation:operationPtr error:outError];
}

- (id)syncPATCH:(NSString *)URLString
     parameters:(NSDictionary *)parameters
      operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
          error:(NSError *__autoreleasing *) outError
{
    return [self synchronouslyPerformMethod:@"PATCH" URLString:URLString parameters:parameters operation:operationPtr error:outError];
}

@end
