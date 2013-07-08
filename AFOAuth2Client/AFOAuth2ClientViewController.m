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

#import "AFOAuth2ClientViewController.h"

@interface AFOAuth2ClientViewController()

@property (nonatomic,strong) UIWebView* webView;
@property (nonatomic,strong) NSString* redirect;
@property (nonatomic,strong) NSString* responseType;
@property (nonatomic,strong) NSString* clientID;
@property (nonatomic,strong) NSString* secret;
@property (nonatomic,strong) NSString* verifyPath;

@end

@implementation AFOAuth2ClientViewController


- (id)initWithBaseURL:(NSString *)baseURL
   authenticationPath:(NSString *)authPath
     verificationPath:(NSString *)verifyPath
         responseType:(NSString *)responseType
             clientID:(NSString *)clientID
               secret:(NSString *)secret
                scope:(NSString *)scope
          redirectURL:(NSString *)redirectURL
             delegate:(id<AFOAuth2ClientViewControllerDelegate>)delegate {

    self.responseType = responseType;
    self.redirect = redirectURL;
    self.clientID = clientID;
    self.secret = secret;
    self.verifyPath = verifyPath;
    self.delegate = delegate;
    
	self = [super init];
	if (self) {
        self.client = [[AFOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:baseURL] clientID:clientID secret:secret];
        if (self.view != nil) {
            NSString* url = [NSString stringWithFormat:@"%@%@?response_type=%@&client_id=%@&redirect_uri=%@&scope=%@",baseURL,authPath,responseType,clientID,redirectURL,scope];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
	}
	return self;
}

/*
 * Grab the code/token from a redirect url.
 * If we get the code, request a token.
 * If we get the token, create a credential with it.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // If we're loading the redirect URL, scan it for parameters (code / token)
    if ([[[request URL] absoluteString] rangeOfString:self.redirect].location != NSNotFound) {
        // Scan the URL for parameters
        NSScanner *scanner = [NSScanner scannerWithString:[[request URL] absoluteString]];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString *tempKey;
        NSString *tempValue;
        [scanner scanUpToString:@"?" intoString:nil]; // Skip to the url parameters
        
        NSString *code, *token, *tokenType;
        
        while ([scanner scanUpToString:@"=" intoString:&tempKey]) {
            [scanner scanUpToString:@"&" intoString:&tempValue];
            if ([tempKey isEqualToString:@"code"]) {
                code = [tempValue substringFromIndex:1];
                NSLog(@"got code: %@", code);
            } else if ([tempKey isEqualToString:@"token"]) {
                token = [tempValue substringFromIndex:1];
                NSLog(@"got token: %@", token);
            } else if ([tempKey isEqualToString:@"token_type"]) {
                tokenType = [tempValue substringFromIndex:1];
                NSLog(@"got token_type: %@", tokenType);
            }
        }
        
        if (code) {
            [self getAccessTokenForCode:code];
        } else if (token) {
            [self setCredentialWithToken:token ofType:tokenType];
        }

        // TODO: Error handling??
    }
}

- (void)getAccessTokenForCode:(NSString *)code
{
    [self.client authenticateUsingOAuthWithPath:self.verifyPath
                                           code:code
                                    redirectURI:self.redirect
                                        success:^(AFOAuthCredential *credential) {
                                            [self.delegate oAuthViewController:self
                                                      didSucceedWithClient:self.client];
                                            [self dismissViewControllerAnimated:YES completion:^() {}];
                                        }
                                        failure:^(NSError *error) {
                                            [self.delegate oAuthViewController:self
                                                              didFailWithError:error];
                                            [self dismissViewControllerAnimated:YES completion:^() {}];
                                        }];
}

- (void)setCredentialWithToken:(NSString *)token ofType:(NSString *)type {
    AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:token tokenType:type];
    [self.client setAuthorizationHeaderWithCredential:credential];
    [self.delegate oAuthViewController:self didSucceedWithClient:self.client];
    [self dismissViewControllerAnimated:YES completion:^() {}];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
	[super loadView];
	self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
	[self.webView setDelegate:self];
	[self.webView setScalesPageToFit:YES];
	[self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
