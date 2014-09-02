//
//  AFOAuth2RequestSerializer.h
//  Workflow
//
//  Created by Conrad Kramer on 8/11/14.
//  Copyright (c) 2014 DeskConnect. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@class AFOAuthCredential;

@interface AFHTTPRequestSerializer (OAuth2)

/**
 Sets the "Authorization" HTTP header set in request objects made by the HTTP client to contain the access token within the OAuth credential. This overwrites any existing value for this header.

 @param credential The OAuth2 credential
 */
- (void)setAuthorizationHeaderFieldWithCredential:(AFOAuthCredential *)credential;

@end
