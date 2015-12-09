Pod::Spec.new do |s|
  s.name     = 'AFOAuth2Manager'
  s.version  = '2.3.0'
  s.license  = 'MIT'
  s.summary  = 'AFNetworking Extension for OAuth 2 Authentication.'
  s.homepage = 'https://github.com/AFNetworking/AFOAuth2Manager'
  s.social_media_url = "https://twitter.com/AFNetworking"
  s.author   = { 'Mattt Thompson' => 'm@mattt.me' }
  s.source   = { :git => 'https://github.com/AFNetworking/AFOAuth2Manager.git', :tag => s.version }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.ios.frameworks = 'Security'

  s.subspec 'Core' do |ss|
    ss.dependency 'AFNetworking/Serialization', '>=2.2'

    ss.source_files = 'AFOAuth2Manager/AFOAuth2Constants.{h,m}', 'AFOAuth2Manager/AFOAuthCredential.{h,m}', 'AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.{h,m}'
  end

  s.subspec 'NSURLConnection' do |ss|
    ss.dependency 'AFOAuth2Manager/Core'
    ss.dependency 'AFNetworking/NSURLConnection', '~>2.2'

    ss.source_files = 'AFOAuth2Manager/AFOAuth2Manager.{h,m}'
  end

  s.subspec 'NSURLSession' do |ss|
    ss.ios.deployment_target = '7.0'
    ss.osx.deployment_target = '10.9'

    ss.dependency 'AFOAuth2Manager/Core'
    ss.dependency 'AFNetworking/NSURLSession', '>=2.2'

    ss.source_files = 'AFOAuth2Manager/AFOAuth2SessionManager.{h,m}'
  end

end
