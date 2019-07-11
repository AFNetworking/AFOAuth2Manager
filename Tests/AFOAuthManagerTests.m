// AFOAuthManagerTests.m
//
// Copyright (c) 2012-2014 AFNetworking (http://afnetworking.com)
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

#import <XCTest/XCTest.h>
#import "AFOAuthCredential.h"
#import "AFOAuth2Manager.h"

@interface AFOAuthManagerTests : XCTestCase

@property (nonatomic, strong) NSURL *baseURL;

@end

@implementation AFOAuthManagerTests

- (void)setUp {

    //Demo OAuth2 App: http://brentertainment.com/oauth2/
    self.baseURL = [NSURL URLWithString:@"http://brentertainment.com/oauth2/"];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUserCredentialsSucceedsWithNoBasicAuthentication {
    AFOAuth2Manager *manager = [[AFOAuth2Manager alloc] initWithBaseURL:self.baseURL
                                                               clientID:@"demoapp"
                                                                 secret:@"demopass"];
    manager.useHTTPBasicAuthentication = NO;

    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];

    [manager
     authenticateUsingOAuthWithURLString:@"lockdin/token"
     username:@"demouser"
     password:@"testpass"
     scope:nil
     success:^(AFOAuthCredential * _Nonnull credential) {
         XCTAssertNotNil(credential);
         XCTAssertNotNil(credential.accessToken);
         XCTAssertTrue([credential.tokenType isEqualToString:@"Bearer"]);
         XCTAssertNotNil(credential.refreshToken);
         [expectation fulfill];
     }
     failure:^(NSError * _Nonnull error) {
         XCTFail(@"Request should succeed");
     }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];

    [manager invalidateSessionCancelingTasks:YES];
}

@end
