// AFOAuth2Client.m
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

#import "AFOAuth2Client.h"

NSString * const kAFOAuthBasicGrantType = @"user_basic";
NSString * const kAFOauthRefreshGrantType = @"refresh_token"; 

@interface AFOAuth2Client ()
@property (readwrite, nonatomic, copy) NSString *serviceProviderIdentifier;
@end

@implementation AFOAuth2Client
@synthesize serviceProviderIdentifier = _serviceProviderIdentifier;

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.serviceProviderIdentifier = [self.baseURL host];
    
    return self;
}

- (void)dealloc {
    [_serviceProviderIdentifier release];
    [super dealloc];
}

- (void)authenticateUsingOAuthWithPath:(NSString *)path
                              username:(NSString *)username
                              password:(NSString *)password
                              clientID:(NSString *)clientID 
                                secret:(NSString *)secret 
                               success:(void (^)(AFOAuthAccount *account))success 
                               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:kAFOAuthBasicGrantType forKey:@"grant_type"];
    [parameters setObject:clientID forKey:@"client_id"];
    [parameters setObject:secret forKey:@"client_secret"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    
    [self authenticateUsingOAuthWithPath:path parameters:parameters success:success failure:failure];
}

- (void)authenticateUsingOAuthWithPath:(NSString *)path
                          refreshToken:(NSString *)refreshToken
                              clientID:(NSString *)clientID 
                                secret:(NSString *)secret 
                               success:(void (^)(AFOAuthAccount *account))success 
                               failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:kAFOauthRefreshGrantType forKey:@"grant_type"];
    [parameters setObject:clientID forKey:@"client_id"];
    [parameters setObject:secret forKey:@"client_secret"];
    [parameters setObject:refreshToken forKey:@"refresh_token"];
    
    [self authenticateUsingOAuthWithPath:path parameters:parameters success:success failure:failure];
}

- (void)authenticateUsingOAuthWithPath:(NSString *)path
                            parameters:(NSDictionary *)parameters 
                               success:(void (^)(AFOAuthAccount *account))success
                               failure:(void (^)(NSError *error))failure
{    
    [self clearAuthorizationHeader];
    
    [self postPath:path parameters:parameters success:^ (AFHTTPRequestOperation *operation, id responseObject) {
        AFOauthAccountCredential *credential = [AFOauthAccountCredential credentialWithOAuthToken:[responseObject valueForKey:@"access_token"] tokenSecret:[parameters valueForKey:@"client_secret"]];
        [credential setRefreshToken:[responseObject valueForKey:@"refresh_token"] expiration:[NSDate dateWithTimeIntervalSinceNow:[[responseObject valueForKey:@"expires_in"] integerValue]]];
        AFOAuthAccount *account = [AFOAuthAccount accountWithUsername:[responseObject valueForKey:@"username"] serviceProviderIdentifier:self.serviceProviderIdentifier credential:credential];
        
        if ([credential isExpired]) {
            if (![[parameters valueForKey:@"grant_type"] isEqualToString:kAFOauthRefreshGrantType]) {
                [self authenticateUsingOAuthWithPath:path refreshToken:credential.refreshToken clientID:[parameters valueForKey:@"client_id"] secret:[parameters valueForKey:@"client_secret"] success:success failure:failure];
            } else {
                if (failure) {
                    failure(nil);
                }
            }
        } else {            
            [self setAuthorizationHeaderWithToken:credential.accessToken];
            
            if (success) {
                success(account);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        } 
    }];
}

@end

#pragma mark -

@interface AFOauthAccountCredential ()
@property (readwrite, nonatomic, copy) NSString *accessToken;
@property (readwrite, nonatomic, copy) NSString *secret;
@property (readwrite, nonatomic, copy) NSString *refreshToken;
@property (readwrite, nonatomic, retain) NSDate *expiration;
@end

@implementation AFOauthAccountCredential
@synthesize accessToken = _accessToken;
@synthesize secret = _secret;
@synthesize refreshToken = _refreshToken;
@synthesize expiration = _expiration;
@dynamic expired;

+ (id)credentialWithOAuthToken:(NSString *)token tokenSecret:(NSString *)secret {
    return [[[self alloc] initWithOAuthToken:token tokenSecret:secret] autorelease];
}

- (id)initWithOAuthToken:(NSString *)token tokenSecret:(NSString *)secret {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.accessToken = token;
    self.secret = secret;
    
    return self;
}

- (void)dealloc {
    [_accessToken release];
    [_secret release];
    [_refreshToken release];
    [_expiration release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ accessToken:\"%@\" secret:\"%@ refreshToken:\"%@\" expiration:\"%@\">", [self class], self.accessToken, self.secret, self.refreshToken, self.expiration];
}

- (void)setRefreshToken:(NSString *)refreshToken expiration:(NSDate *)expiration {
    if (!refreshToken || !expiration) {
        return;
    }
    
    self.refreshToken = refreshToken;
    self.expiration = expiration;
}

- (BOOL)isExpired {
    return [self.expiration compare:[NSDate date]] == NSOrderedAscending;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
    self.secret = [decoder decodeObjectForKey:@"secret"];
    self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
    self.expiration = [decoder decodeObjectForKey:@"expiration"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.secret forKey:@"secret"];
    [encoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [encoder encodeObject:self.expiration forKey:@"expiration"];
}

@end

#pragma mark -

@interface AFOAuthAccount ()
@property (readwrite, nonatomic, copy) NSString *username;
@property (readwrite, nonatomic, copy) NSString *serviceProviderIdentifier;
@property (readwrite, nonatomic, retain) AFOauthAccountCredential *credential;
@end

@implementation AFOAuthAccount
@synthesize username = _username;
@synthesize serviceProviderIdentifier = _serviceProviderIdentifier;
@synthesize credential = _credential;

+ (id)accountWithUsername:(NSString *)username serviceProviderIdentifier:(NSString *)identifier credential:(AFOauthAccountCredential *)credential {
    return [[[self alloc] initWithUsername:username serviceProviderIdentifier:identifier credential:credential] autorelease];
}

- (id)initWithUsername:(NSString *)username serviceProviderIdentifier:(NSString *)identifier credential:(AFOauthAccountCredential *)credential {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.username = username;
    self.serviceProviderIdentifier = identifier;
    self.credential = credential;
    
    return self;
}

- (void)dealloc {
    [_username release];
    [_serviceProviderIdentifier release];
    [_credential release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ provider:\"%@\" username:\"%@\" credential:%@>", [self class], self.serviceProviderIdentifier, self.username, self.credential];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.username = [decoder decodeObjectForKey:@"username"];
    self.serviceProviderIdentifier = [decoder decodeObjectForKey:@"serviceProviderIdentifier"];
    self.credential = [decoder decodeObjectForKey:@"credential"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.serviceProviderIdentifier forKey:@"serviceProviderIdentifier"];
    [encoder encodeObject:self.credential forKey:@"credential"];
}

@end
