#
# Be sure to run `pod lib lint Touch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Touch'
  s.version          = '0.9.0'
  s.summary          = 'Touch platform iOS SDK'
  s.description      = <<-DESC
  Touch platform iOS SDK by Engagecraft. Widget load helpers.
                       DESC

  s.homepage         = 'https://github.com/Engagecraft-Solutions/touch-platform-widgets-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aurimas Petrevicius' => 'aurimas@engagecraft.com' }
  s.source           = { :git => 'https://github.com/Engagecraft-Solutions/touch-platform-widgets-ios.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'

  s.source_files = 'Touch/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Touch' => ['Touch/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
