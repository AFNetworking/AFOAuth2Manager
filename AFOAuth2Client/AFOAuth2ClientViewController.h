// AFOAuth1ClientViewController.m
//
// Copyright (c) 2013 Lari Haataja (http://larihaataja.fi)
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

#import <UIKit/UIKit.h>
#import "AFOAuth2Client.h"

@class AFOAuth2ClientViewController;

@protocol AFOAuth2ClientViewControllerDelegate <NSObject>

@optional
- (void)oAuthViewController:(AFOAuth2ClientViewController *)viewController didSucceedWithCredential:(AFOAuthCredential *)credential;
- (void)oAuthViewController:(AFOAuth2ClientViewController *)viewController didFailWithError:(NSError *)error;

@end

@interface AFOAuth2ClientViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,strong) AFOAuth2Client* client;
@property (nonatomic,assign) id<AFOAuth2ClientViewControllerDelegate> delegate;

/**
 Init view controller
 
 @param baseURL     the api's base url (e.g. https://googleapis.com/ )
 @param authPath    path for authorization request
 @param verifyPath  path for access token request
 @param clientID    OAuth2 client id
 @param secret      OAuth2 client secret
 @param scope       Requested scope (e.g. "read" or "read+write")
 @param redirectURL url where the user is redirected after authorization
*/
- (id)initWithBaseURL:(NSString *)baseURL
   authenticationPath:(NSString *)authPath
     verificationPath:(NSString *)verifyPath
             clientID:(NSString *)clientID
               secret:(NSString *)secret
                scope:(NSString *)scope
          redirectURL:(NSString *)redirectURL
             delegate:(id<AFOAuth2ClientViewControllerDelegate>)delegate;

/**
 Configure view controller that's reused or loaded from xib
 
 @param baseURL     the api's base url (e.g. https://googleapis.com/ )
 @param authPath    path for authorization request
 @param verifyPath  path for access token request
 @param clientID    OAuth2 client id
 @param secret      OAuth2 client secret
 @param scope       Requested scope (e.g. "read" or "read+write")
 @param redirectURL url where the user is redirected after authorization
 */
- (void)configureWithBaseURL:(NSString *)baseURL
          authenticationPath:(NSString *)authPath
            verificationPath:(NSString *)verifyPath
                    clientID:(NSString *)clientID
                      secret:(NSString *)secret
                       scope:(NSString *)scope
                 redirectURL:(NSString *)redirectURL
                    delegate:(id<AFOAuth2ClientViewControllerDelegate>)delegate;

/*
 * Load the authorization page
 */
- (void)authorize;

@end



