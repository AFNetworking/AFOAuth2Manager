// AFOAuth1ClientViewController.m
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

#import <UIKit/UIKit.h>
#import "AFOAuth2Client.h"

@protocol AFOAuth2ClientViewControllerDelegate <NSObject>

@optional
- (void)didGetCredentials:(AFOAuthCredential *)credentials;
- (void)didFailWithError:(NSError *)error;

@end

@interface AFOAuth2ClientViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,strong) AFOAuth2Client* client;
@property (nonatomic,assign) id<AFOAuth2ClientViewControllerDelegate> delegate;

- (id)initWithBaseURL:(NSString *)baseURL
             clientID:(NSString *)clientID
               secret:(NSString *)secret
                 path:(NSString *)path
                scope:(NSString *)scope
          redirectURL:(NSString *)redirectURL
             delegate:(id<AFOAuth2ClientViewControllerDelegate>)delegate;

@end
