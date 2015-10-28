#Change Log
All notable changes to this project will be documented in this file.
`AFNetworking` adheres to [Semantic Versioning](http://semver.org/).

---

## [2.2.1](https://github.com/AFNetworking/AFOAuth2Manager/releases/tag/2.2.1) (2015-10-28)
Released on 2015-10-28. All issues associated with this milestone can be found using this [filter](https://github.com/AFNetworking/AFOAuth2Manager/milestones/2.2.1).
	
####Fixed

* Fixed an issue that prevented `AFOAuth2Manager` from being used with CocoaPods when using `use_framework!`
	* Fixed by [juanuribeo13](https://github.com/juanuribeo13) in [#100](https://github.com/AFNetworking/AFOAuth2Manager/pull/100).
* Fixed an issue debug information was being logged to the console.
	* Fixed by [Sven Münnich](https://github.com/svenmuennich) in [#99](https://github.com/AFNetworking/AFOAuth2Manager/pull/99).
* Fixed an issue where tests would randomly fail due to mocked objects not being cleaned up.
	* Fixed by [Pritesh Shah](https://github.com/priteshshah1983) in [#96](https://github.com/AFNetworking/AFOAuth2Manager/pull/96).