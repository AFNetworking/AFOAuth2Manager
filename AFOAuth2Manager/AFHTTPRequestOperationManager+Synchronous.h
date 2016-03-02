// AFHTTPRequestOperationManager+Synchronous.h
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

#import "AFHTTPRequestOperationManager.h"

/**
 
 ## First, consider adopting an asynchronous design
 
 Before you decide to use this category, consider whether you can adopt an asynchronous design instead. As @mattt wrote, asynchronism a tough thing to get your head around, but it's well worth the mental overhead. Rather than creating methods that fetch and return network data, use blocks or delegate methods to call back with the results when you have them.
 
 Using the asynchronous API has many advantages:
 
 - When you start an operation on the main thread, you return control to the run loop immediately, so your UI can remains responsive. Blocking the main thread for a long time is never a good idea. "Be responsive," Appe urges in the OS X user experience guidelines. Asynchronous network operations allow you to do that.
 - AFNetworking makes asynchronous code easy to write and easy to read. With block-based success and failure handlers, you don't need to implement delegate protocols or provide selectors for callbacks.
 - AFNetworking and Grand Central Dispatch take care of threading for you, so your code does not need to manage threads, run selectors in the background, or invoke dispatch_async. Your completion blocks will be executed on the main thread (unless you configure the operations otherwise).
 - You can provide a better user experience while waiting for a response. Networks are unreliable, particularly for mobile users, and servers can be bogged down. Your users' experiences will be better if you design for a slow connection, which you can only do asynchronously.
 
 However, in some cases, a synchronous response is better, such as when the document architecture or another framework is handling the multithreading for you, and expects a synchronous result. This code attempts to provide a safe and reliable way to use the framework synchronously.
 
 While it overrides the default success and failure queues to avoid a deadlock, it can't anticipate every possible situation. In particular, you should not set the queue from which you're invoking as the processing queue, which will cause a deadlock.
 
 ## The Main Thread
 
 You shouldn't call these methods from the main thread. On iOS, if your application enters the background while one of these methods is running on the main thread, a deadlock may result and your application could be terminated.
 
 ## AFImageRequestOperation processingBlock and custom operation subclasses
 
 This category is suitable for most of the request operation subclasses built into AFNetworking, which process their response objects synchronously. If you're using the processingBlock on AFImageRequestOperation, which contains essential processing in the completion handler, or your subclass performs other asynchronous processing in the completion handler, use the version in the using-completion-blocks branch instead.
 
 All custom subclasses must override `-responseObject`. See AFHTTPRequestOperation+ResponseObject.h for more information.
*/
@interface AFHTTPRequestOperationManager (Synchronous)

- (id)syncGET:(NSString *)path
   parameters:(NSDictionary *)parameters
    operation:(AFHTTPRequestOperation *__autoreleasing *)operationPtr
        error:(NSError *__autoreleasing *)outError;

- (id)syncPOST:(NSString *)path
    parameters:(NSDictionary *)parameters
     operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
         error:(NSError *__autoreleasing *) outError;

- (id)syncPUT:(NSString *)path
   parameters:(NSDictionary *)parameters
    operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
        error:(NSError *__autoreleasing *) outError;

- (id)syncDELETE:(NSString *)path
      parameters:(NSDictionary *)parameters
       operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
           error:(NSError *__autoreleasing *) outError;

- (id)syncPATCH:(NSString *)path
     parameters:(NSDictionary *)parameters
      operation:(AFHTTPRequestOperation *__autoreleasing *) operationPtr
          error:(NSError *__autoreleasing *) outError;

- (id)synchronouslyPerformMethod:(NSString *)method
                       URLString:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                       operation:(AFHTTPRequestOperation *__autoreleasing *)operationPtr
                           error:(NSError *__autoreleasing *)outError;

@end
