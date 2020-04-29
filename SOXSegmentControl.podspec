#
# Be sure to run `pod lib lint SOXSegmentControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guidespec.cocoapodspec.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'SOXSegmentControl'
  spec.version          = '0.1.0'
  spec.summary          = 'Just another replacement for segment controls with multiline support of multi-lined segments.'

# This description is used to generate tags and improve search resultspec.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  spec.description      = 'As other cocoapods it allows to flexible configure you own segment control. 
  But in different you have the option to order you segments in a multilined pattern. Its the first alpha release so there is not a documentation, but take a look at the example project.
  Based on the idea of WMSegmentControl.'

  spec.homepage         = 'https://github.com/twilightDD/SOXSegmentControl'
  # spec.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'twilightDD' => 'peter@2sox.de' }
  spec.source           = { :git => 'https://github.com/twilightDD/SOXSegmentControl.git', :tag => spec.version.to_s }
  spec.social_media_url = 'https://twitter.com/twilightDD'

  spec.ios.deployment_target = '13.0'
  spec.swift_version = '5.0'

  spec.source_files = 'SOXSegmentControl/Classes/**/*'
  
  # spec.resource_bundles = {
  #   'SOXSegmentControl' => ['SOXSegmentControl/Assets/*.png']
  # }

  # spec.public_header_files = 'Pod/Classes/**/*.h'
  # spec.frameworks = 'UIKit', 'MapKit'
  # spec.dependency 'AFNetworking', '~> 2.3'
end
