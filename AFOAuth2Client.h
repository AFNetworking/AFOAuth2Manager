// AFOAuth2Client.h
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me/)
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

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

extern NSString * const kAFOAuthBasicGrantType;
extern NSString * const kAFOauthRefreshGrantType;

@class AFOAuthAccount;

@interface AFOAuth2Client : AFHTTPClient

@property (readonly, nonatomic, copy) NSString *serviceProviderIdentifier;

- (void)authenticateUsingOAuthWithPath:(NSString *)path
                              username:(NSString *)username
                              password:(NSString *)password
                              clientID:(NSString *)clientID 
                                secret:(NSString *)secret 
                               success:(void (^)(AFOAuthAccount *account))success 
                               failure:(void (^)(NSError *error))failure;

- (void)authenticateUsingOAuthWithPath:(NSString *)path
                          refreshToken:(NSString *)refreshToken
                              clientID:(NSString *)clientID 
                                secret:(NSString *)secret 
                               success:(void (^)(AFOAuthAccount *account))success 
                               failure:(void (^)(NSError *error))failure;

- (void)authenticateUsingOAuthWithPath:(NSString *)path
                            parameters:(NSDictionary *)parameters 
                               success:(void (^)(AFOAuthAccount *account))success
                               failure:(void (^)(NSError *error))failure;

@end

#pragma mark -

@interface AFOauthAccountCredential : NSObject <NSCoding>

@property (readonly, nonatomic, copy) NSString *accessToken;
@property (readonly, nonatomic, copy) NSString *secret;
@property (readonly, nonatomic, copy) NSString *refreshToken;
@property (readonly, nonatomic, assign, getter = isExpired) BOOL expired;

+ (id)credentialWithOAuthToken:(NSString *)token tokenSecret:(NSString *)secret;
- (id)initWithOAuthToken:(NSString *)token tokenSecret:(NSString *)secret;

- (void)setRefreshToken:(NSString *)refreshToken expiration:(NSDate *)expiration;

@end

#pragma mark -

@interface AFOAuthAccount : NSObject <NSCoding>

@property (readonly, nonatomic, copy) NSString *username;
@property (readonly, nonatomic, copy) NSString *serviceProviderIdentifier;
@property (readonly, nonatomic, retain) AFOauthAccountCredential *credential;

+ (id)accountWithUsername:(NSString *)username serviceProviderIdentifier:(NSString *)identifier credential:(AFOauthAccountCredential *)credential;
- (id)initWithUsername:(NSString *)username serviceProviderIdentifier:(NSString *)identifier credential:(AFOauthAccountCredential *)credential;

@end
