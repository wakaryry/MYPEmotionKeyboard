@version = '0.2.0'

Pod::Spec.new do |s|
  s.name             = 'MYPEmotionKeyboard'
  s.version          = @version
  s.summary          = 'A delegant emotion keyboard.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Emotion keyboard. Easy to use.
                       DESC

  s.homepage         = 'https://github.com/wakaryry/MYPEmotionKeyboard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wakary' => 'redoume@163.com' }
  s.source           = { :git => 'https://github.com/wakaryry/MYPEmotionKeyboard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.0'

  s.source_files = 'MYPEmotionKeyboard/Classes/**/*'
  
  s.resource_bundles = {
     'MYPEmotionKeyboard' => ['MYPEmotionKeyboard/Assets/*.png', 'MYPEmotionKeyboard/Assets/*.xib',
'MYPEmotionKeyboard/Assets/*.plist']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
