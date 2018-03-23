
Pod::Spec.new do |s|
  s.name             = 'SKCache'
  s.version          = '1.1.0'
  s.summary          = 'Simple cache holder for all supported Swift types'
 
  s.description      = 'This Library allows to cache all known types in Swift'
 
  s.homepage         = 'https://github.com/dev-labs-bg/SKCache'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Steliyan Hadzhidenev' => 'hadzhidenev@gmail.com' }
  s.source           = { :git => 'https://github.com/dev-labs-bg/SKCache.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
  s.source_files = 'FantasticView/FantasticView.swift'
 
end