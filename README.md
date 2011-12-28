# AFOAuth2Client

AFOAuth2Client is an extension for [AFNetworking](http://github.com/AFNetworking/AFNetworking/) that greatly simplifies the process of authenticating against an [OAuth 2](http://oauth.net/2/) provider.

This is still in early stages of development, so proceed with caution when using this in a production application. Any bug reports, feature requests, or general feedback at this point would be greatly appreciated.

## Example Usage

``` objective-c
NSURL *url = [NSURL URLWithString:@"http://example.com/"];
AFOAuth2Client *oauthClient = [AFOAuthClient clientWithBaseURL:url];
[oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];

[oauthClient authenticateUsingOAuthWithPath:@"/oauth/token" 
                                   username:@"username"
                                   password:@"pa55word"
                                   clientID:kClientID
                                     secret:kClientSecret 
                                    success:^(AFOAuthAccount *account) {
                                      NSLog(@"Credentials: %@", credential.accessToken);
                                      // If you are already using AFHTTPClient in your application, this would be a good place to set your `Authorization` header.
                                      // [HTTPClient setAuthorizationHeaderWithToken:credential.accessToken];
                                    }
                                    failure:^(NSError *error) {
                                      NSLog(@"Error: %@", error);
                                    }];
```

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

AFOAuth2Client is available under the MIT license. See the LICENSE file for more info.
