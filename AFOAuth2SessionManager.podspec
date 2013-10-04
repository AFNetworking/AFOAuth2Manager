Pod::Spec.new do |s|
  s.name     = 'AFOAuth2SessionManager'
  s.version  = '0.2.0'
  s.license  = 'MIT'
  s.summary  = 'AFNetworking Extension for OAuth 2 Authentication.'
  s.homepage = 'https://github.com/gabrielrinaldi/AFOAuth2SessionManager'
  s.author   = { 'Gabriel Rinaldi' => 'gabriel@gabrielrinaldi.me', 'Mattt Thompson' => 'm@mattt.me' }
  s.source   = { :git => 'https://github.com/gabrielrinaldi/AFOAuth2SessionManager.git',
                 :tag => '0.2.0' }
  s.source_files = 'AFOAuth2SessionManager'
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.dependency 'AFNetworking', '~>2.0'

  s.ios.frameworks = 'Security'

  s.prefix_header_contents = <<-EOS
#ifdef __OBJC__
  #import <Security/Security.h>
#endif /* __OBJC__*/
EOS
end
