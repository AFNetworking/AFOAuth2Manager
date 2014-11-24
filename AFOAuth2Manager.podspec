Pod::Spec.new do |s|
  s.name     = 'AFOAuth2Manager'
  s.version  = '2.0.0'
  s.license  = 'MIT'
  s.summary  = 'AFNetworking Extension for OAuth 2 Authentication.'
  s.homepage = 'https://github.com/AFNetworking/AFOAuth2Manager'
  s.social_media_url = "https://twitter.com/AFNetworking"
  s.author   = { 'Mattt Thompson' => 'm@mattt.me' }
  s.source   = { :git => 'https://github.com/AFNetworking/AFOAuth2Manager.git',
                 :tag => '2.0.0' }
  s.source_files = 'AFOAuth2Manager'
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.dependency 'AFNetworking', '~>2.2'

  s.ios.frameworks = 'Security'
end
