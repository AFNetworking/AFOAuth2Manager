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

#import "AFOAuth2ClientViewController.h"

@interface AFOAuth2ClientViewController()

@property (nonatomic,strong) UIWebView* webView;
@property (nonatomic,strong) NSString* redirect;

@end

@implementation AFOAuth2ClientViewController

- (id)initWithBaseURL:(NSString *)baseURL
             clientID:(NSString *)clientID
               secret:(NSString *)secret
                 path:(NSString *)path
                scope:(NSString *)scope
          redirectURL:(NSString *)redirectURL
             delegate:(id<AFOAuth2ClientViewControllerDelegate>)delegate {

	self = [super init];
	if (self) {
        self.client = [[AFOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:baseURL] clientID:clientID secret:secret];
        if (self.view != nil) {
            NSString* url = [NSString stringWithFormat:@"%@%@?response_type=token%%20id_token&client_id=%@&redirect_uri=%@&scope=%@",baseURL,path,clientID,redirectURL,scope];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
	}
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL] host];
    NSLog(@"Will load: %@", [[request URL] absoluteString]);
    if ([url isEqualToString:@"localhost"]) {
        
        NSString *code;
        
        NSScanner *scanner = [NSScanner scannerWithString:[[request URL] absoluteString]];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString *tempKey;
        NSString *tempValue;
        [scanner scanUpToString:@"?" intoString:nil]; //ignore the beginning of the string and skip to the vars
        while ([scanner scanUpToString:@"=" intoString:&tempKey]) {
            [scanner scanUpToString:@"&" intoString:&tempValue];
            if ([tempKey isEqualToString:@"code"]) {
                code = [tempValue substringFromIndex:1];
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OAuth"
                                                        message:[NSString stringWithFormat:@"Your OAuth code is %@", code]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:^() {}];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString* urlString = [[webView.request URL]absoluteString];
    
    NSLog(@"Webview loaded url: %@", urlString);
    
	if ([urlString rangeOfString:@"oauth_verifier"].location != NSNotFound) {
		NSString* verifier = [[urlString componentsSeparatedByString:@"="]lastObject];
		//self.client.accessToken.verifier = verifier;
		[self getAccessToken];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)getAccessToken
{
	/*[self.client acquireOAuthAccessTokenWithPath:self.accessTokenPath requestToken:self.client.accessToken accessMethod:self.accessMethod success:^(AFOAuth1Token *accessToken, id responseObject) {
		self.client.accessToken = accessToken;
		[self.delegate didGetAccessPermissionWithClient:self.client attributes:[self.client parametersFromResponseObject:responseObject]];
	} failure:^(NSError *error) {
		NSLog(@"%@",error);
	}];*/
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
