//
//  AFOAuthCredentialTests.m
//  AFOAuth2Manager
//
//  Created by Kevin Harwood on 12/7/15.
//  Copyright © 2015 Alamofire. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AFOAuthCredential.h"

@interface AFOAuthCredentialTests : XCTestCase

@end

@implementation AFOAuthCredentialTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCredentialExpiration {
    AFOAuthCredential *credential = [[AFOAuthCredential alloc] initWithOAuthToken:@"token" tokenType:@"Bearer"];
    [credential setExpiration:[NSDate distantPast]];
    XCTAssertTrue(credential.expired);

    [credential setRefreshToken:@"refresh" expiration:[NSDate distantFuture]];
    XCTAssertFalse(credential.expired);
}

- (void)testCredentialStorage {
    AFOAuthCredential *credential = [[AFOAuthCredential alloc] initWithOAuthToken:@"token" tokenType:@"Bearer"];
    NSString *identifier = [[NSUUID UUID] UUIDString];
    XCTAssertTrue([AFOAuthCredential storeCredential:credential withIdentifier:identifier]);

    [credential setRefreshToken:@"updated_token" expiration:[NSDate distantFuture]];
    XCTAssertTrue([AFOAuthCredential storeCredential:credential withIdentifier:identifier]);

    AFOAuthCredential *retrievedCred = [AFOAuthCredential retrieveCredentialWithIdentifier:identifier];
    XCTAssertNotNil(retrievedCred);

    XCTAssertTrue([retrievedCred.refreshToken isEqualToString:credential.refreshToken]);

    XCTAssertTrue([AFOAuthCredential deleteCredentialWithIdentifier:identifier]);
}
@end
