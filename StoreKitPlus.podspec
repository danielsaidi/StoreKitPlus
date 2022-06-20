# Run `pod lib lint StoreKitPlus.podspec' to ensure this is a valid spec.

Pod::Spec.new do |s|
  s.name             = 'StoreKitPlus'
  s.version          = '0.0.0'
  s.swift_versions   = ['5.6']
  s.summary          = 'StoreKitPlus contains additional functionality for working with StoreKit 2.'

  s.description      = <<-DESC
  StoreKitPlus contains additional functionality for working with StoreKit 2, like extensions, new types, services etc.
                       DESC

  s.homepage         = 'https://github.com/danielsaidi/StoreKitPlus'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Saidi' => 'daniel.saidi@gmail.com' }
  s.source           = { :git => 'https://github.com/danielsaidi/StoreKitPlus.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/danielsaidi'

  s.swift_version = '5.6'
  s.ios.deployment_target = '15.0'
  s.macos.deployment_target = '12.0'
  s.tvos.deployment_target = '15.0'
  s.watchos.deployment_target = '8.0'
  
  s.source_files = 'Sources/**/*.swift'
end
