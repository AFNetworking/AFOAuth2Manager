//
//  AFOAuth2RequestSerializer.h
//  Workflow
//
//  Created by Conrad Kramer on 8/11/14.
//  Copyright (c) 2014 DeskConnect. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@class AFOAuthCredential;

@interface AFOAuth2RequestSerializer : AFHTTPRequestSerializer

- (void)setAuthorizationHeaderFieldWithCredential:(AFOAuthCredential *)credential;

@end
