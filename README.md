# AFOAuth2Client

AFOAuth2Client is an extension for [AFNetworking](http://github.com/AFNetworking/AFNetworking/) that greatly simplifies the process of authenticating against an [OAuth 2](https://tools.ietf.org/html/rfc6749) provider.

## Example Usage

### Authentication

```objective-c
NSURL *baseURL = [NSURL URLWithString:@"http://example.com/"];
AFOAuth2Client *OAuth2Client = [AFOAuth2Client clientWithBaseURL:baseURL
                                                        clientID:kClientID
                                                          secret:kClientSecret];

[OAuth2Client authenticateUsingOAuthWithPath:@"/oauth/token"
                                    username:@"username"
                                    password:@"password"
                                       scope:@"email"
                                     success:^(AFOAuthCredential *credential) {
                                         NSLog(@"Token: %@", credential.accessToken);
                                     }
                                     failure:^(NSError *error) {
                                         NSLog(@"Error: %@", error);
                                     }];
```

### Authorizing Requests

```objective-c
AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:baseURL];
[client setDefaultHeader:@"Authorization"
                   value:[NSString stringWithFormat:@"Bearer %@", credential.accessToken]];


[client getPath:@"/path/to/protected/resource"
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure: %@", error);
        }];
```

### Storing Credentials

```objective-c
[AFOAuthCredential storeCredential:credential
                    withIdentifier:serviceProviderIdentifier];
```

### Retrieving Credentials

```objective-c
AFOAuthCredential *credential =
        [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
```

## Documentation

Documentation for all releases of AFOAuth2Client are [available on CocoaDocs](http://cocoadocs.org/docsets/AFOAuth2Client/).

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

AFOAuth2Client is available under the MIT license. See the LICENSE file for more info.
