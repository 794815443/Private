#
# Be sure to run `pod lib lint Private.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Private'
  s.version          = '0.2.1'
  s.summary          = 'A short description of Private222.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'ni hao '
  s.homepage         = 'https://github.com/794815443/Private.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nick' => '794815443@qq.com' }
  s.source           = { :git => 'https://github.com/794815443/Private.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  # 只支持 arm64 架构
  s.pod_target_xcconfig = { 'ARCHS' => 'arm64' }
  s.user_target_xcconfig = { 'ARCHS' => 'arm64' }

  s.source_files = 'Private/Classes/**/*'
  
  # OpenCV 配置
  s.vendored_frameworks = 'Private/libs/opencv2.framework'
#    s.vendored_frameworks = 'libs/opencv2.framework'
#    s.vendored_frameworks = 'opencv2.framework'
#  s.preserve_paths = 'Private/libs/opencv2.framework'
#s.pod_target_xcconfig = {'VALID_ARCHS' => 'x86_64 arm64'}
  s.frameworks = [
      'Accelerate',
      'AssetsLibrary',
      'AVFoundation',
      'CoreGraphics',
      'CoreImage',
      'CoreMedia',
      'CoreVideo',
      'Foundation',
      'QuartzCore',
      'UIKit'
    ]
  
  # OpenCV 所需的系统库
  s.libraries = 'sqlite3', 'z', 'c++', 'stdc++'
  
  s.xcconfig = { 
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
    'CLANG_CXX_LIBRARY' => 'libc++'
  }

  # s.resource_bundles = {
  #   'Private' => ['Private/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
