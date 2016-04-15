#Change Log
All notable changes to this project will be documented in this file.
`AFNetworking` adheres to [Semantic Versioning](http://semver.org/).

--- 

## [3.0.0](https://github.com/AFNetworking/AFOAuth2Manager/releases/tag/3.0.0) (04/15/2016)
Released on Friday, April 15, 2016. All issues associated with this milestone can be found using this [filter](https://github.com/AFNetworking/AFOAuth2Manager/issues?q=milestone%3A3.0.0+is%3Aclosed).

#### Added
* Added Travis Support for CI
 * Implemented by kcharwood in [#124](https://github.com/AFNetworking/AFOAuth2Manager/issues/124).
* Added Carthage support
 * Implemented by kcharwood in [#123](https://github.com/AFNetworking/AFOAuth2Manager/issues/123).
* Added tvOS support
 * Implemented by kcharwood in [#120](https://github.com/AFNetworking/AFOAuth2Manager/issues/120).
* Added watchOS support
 * Implemented by kcharwood in [#119](https://github.com/AFNetworking/AFOAuth2Manager/issues/119).

#### Changed
* Changed `AFOAuth2Manager` to inherit from `AFHTTPSessionManager` to support AFNetworking 3.0 
 * Implemented by kcharwood in [#122](https://github.com/AFNetworking/AFOAuth2Manager/issues/122).

#### Removed
* Removed support for AFNetworking 2.x
 * Implemented by kcharwood in [#121](https://github.com/AFNetworking/AFOAuth2Manager/issues/121).


## [2.2.1](https://github.com/AFNetworking/AFOAuth2Manager/releases/tag/2.2.1) (2015-10-28)
Released on 2015-10-28. All issues associated with this milestone can be found using this [filter](https://github.com/AFNetworking/AFOAuth2Manager/milestones/2.2.1).
	
####Fixed

* Fixed an issue that prevented `AFOAuth2Manager` from being used with CocoaPods when using `use_framework!`
	* Fixed by [juanuribeo13](https://github.com/juanuribeo13) in [#100](https://github.com/AFNetworking/AFOAuth2Manager/pull/100).
* Fixed an issue debug information was being logged to the console.
	* Fixed by [Sven Münnich](https://github.com/svenmuennich) in [#99](https://github.com/AFNetworking/AFOAuth2Manager/pull/99).
* Fixed an issue where tests would randomly fail due to mocked objects not being cleaned up.
	* Fixed by [Pritesh Shah](https://github.com/priteshshah1983) in [#96](https://github.com/AFNetworking/AFOAuth2Manager/pull/96).