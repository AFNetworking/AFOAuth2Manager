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

@interface AFOAuth2ClientViewController() {
    NSTimer *timer;
    BOOL spinnerActive;
}

@property (nonatomic,strong) UIWebView* webView;
@property (nonatomic,strong) NSString* baseURL;
@property (nonatomic,strong) NSString* redirect;
@property (nonatomic,strong) NSString* clientID;
@property (nonatomic,strong) NSString* secret;
@property (nonatomic,strong) NSString* authPath;
@property (nonatomic,strong) NSString* verifyPath;
@property (nonatomic,strong) NSString* scope;

@end

@implementation AFOAuth2ClientViewController


- (id)initWithBaseURL:(NSString *)baseURL
   authenticationPath:(NSString *)authPath
     verificationPath:(NSString *)verifyPath
             clientID:(NSString *)clientID
               secret:(NSString *)secret
                scope:(NSString *)scope
          redirectURL:(NSString *)redirectURL
             delegate:(id<AFOAuth2ClientViewControllerDelegate>)delegate {

    self.baseURL = baseURL;
    self.redirect = redirectURL;
    self.clientID = clientID;
    self.secret = secret;
    self.authPath = authPath;
    self.verifyPath = verifyPath;
    self.delegate = delegate;
    self.scope = scope;
    spinnerActive = NO;
    
	self = [super init];
	if (self) {
        self.client = [[AFOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:baseURL] clientID:clientID secret:secret];
	}
	return self;
}

- (void)configureWithBaseURL:(NSString *)baseURL
          authenticationPath:(NSString *)authPath
            verificationPath:(NSString *)verifyPath
                    clientID:(NSString *)clientID
                      secret:(NSString *)secret
                       scope:(NSString *)scope
                 redirectURL:(NSString *)redirectURL
                    delegate:(id<AFOAuth2ClientViewControllerDelegate>)delegate {
    
    self.baseURL = baseURL;
    self.redirect = redirectURL;
    self.clientID = clientID;
    self.secret = secret;
    self.authPath = authPath;
    self.verifyPath = verifyPath;
    self.delegate = delegate;
    self.scope = scope;
    spinnerActive = NO;
    
    self.client = [[AFOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:baseURL] clientID:clientID secret:secret];
}

- (void)authorize {
    NSString* url = [NSString stringWithFormat:@"%@%@?response_type=code&client_id=%@&redirect_uri=%@&scope=%@",self.baseURL,self.authPath,self.clientID,self.redirect,self.scope];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.title = @"Login";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelLogin:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self authorize];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 * Request the access token with the code (use AFOAuth2Client)
 */
- (void)getAccessTokenForCode:(NSString *)code
{
    [self.client authenticateUsingOAuthWithPath:self.verifyPath
                                           code:code
                                    redirectURI:self.redirect
                                        success:^(AFOAuthCredential *credential) {
                                            [self dismissViewControllerAnimated:YES completion:^() {
                                                [self.delegate oAuthViewController:self
                                                          didSucceedWithCredential:credential];
                                            }];
                                        }
                                        failure:^(NSError *error) {
                                            [self dismissViewControllerAnimated:YES completion:^() {
                                                [self.delegate oAuthViewController:self
                                                                  didFailWithError:error];
                                            }];
                                        }];
}

/*
 * On error, send error message to delegate and dismiss view controller
 */
- (void)failWithErrorCode:(NSInteger)code description:(NSString *)description recoverySuggestion:(NSString *)suggestion {
    [self dismissViewControllerAnimated:YES completion:^() {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:description forKey:NSLocalizedDescriptionKey];
        [details setValue:suggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
        NSError *e = [NSError errorWithDomain:@"oauth" code:code userInfo:details];
        [self.delegate oAuthViewController:self didFailWithError:e];
    }];
}

/**
 Handle cancel button
 */
- (void)cancelLogin:(id)sender {
    [self failWithErrorCode:100 description:@"Login cancelled." recoverySuggestion:@""];
}

#pragma mark - UIWebViewDelegate methods

/**
 Grab the code/token from a redirect url.
 If we get the code, request a token.
 If we get the token, create a credential with it.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // If we're loading the redirect URL, scan it for parameters (code / token)
    if ([[[request URL] absoluteString] rangeOfString:self.redirect].location != NSNotFound
        && [[[request URL] host] isEqualToString:[[NSURL URLWithString:self.redirect] host]]) {
        
        // Scan the URL for parameters
        NSScanner *scanner = [NSScanner scannerWithString:[[request URL] absoluteString]];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString *tempKey;
        NSString *tempValue;
        [scanner scanUpToString:@"?" intoString:nil]; // Skip to the url parameters
        
        NSString *code, *token, *tokenType, *errorCode, *errorMsg;
        
        while ([scanner scanUpToString:@"=" intoString:&tempKey]) {
            [scanner scanUpToString:@"&" intoString:&tempValue];
            if ([tempKey isEqualToString:@"code"]) {
                code = [tempValue substringFromIndex:1];
            } else if ([tempKey isEqualToString:@"error"]) {
                errorCode = [tempValue substringFromIndex:1];
            } else if ([tempKey isEqualToString:@"error_description"]) {
                errorMsg = [tempValue substringFromIndex:1];
            }
        }
        
        // Check which parameters we got and act based on those
        if (code) {
            [self getAccessTokenForCode:code];
        } else if (errorCode) {
            // Add error message if we don't get it from server
            if (!errorMsg) {
                if ([errorCode isEqualToString:@"access_denied"]) {
                    errorMsg = @"Request denied by user or server.";
                }
            }
            [self failWithErrorCode:errorCode description:errorMsg recoverySuggestion:@""];
        } else {
            [self failWithErrorCode:100 description:@"Could not resolve server response (no code or token received)." recoverySuggestion:@"Make sure that you get a code or token from the server."];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // Set 2 minute timeout and start the spinner
    timer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    [self displaySpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [timer invalidate];
    [self hideSpinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [timer invalidate];
    [self hideSpinner];
}


#pragma mark - Spinner and timeout management

- (void)displaySpinner {
    if (!spinnerActive) {
        UIView *spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
        [spinnerView setBackgroundColor:[UIColor clearColor]];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner setFrame:CGRectMake(6.0, 6.0, 20.0, 20.0)];
        
        [spinnerView addSubview:spinner];
        
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:spinnerView];
        [self.navigationItem setRightBarButtonItem:barButton];
        [spinner startAnimating];
    }
    spinnerActive = YES;
}

- (void)hideSpinner {
    spinnerActive = NO;
    [self.navigationItem setRightBarButtonItem:nil];
}

/**
 Handle timeout
 */
- (void)timeout {
    [self failWithErrorCode:100 description:@"Request timed out." recoverySuggestion:@"Check the network connection and try again later."];
    [self cancelLogin:self];
}

@end
