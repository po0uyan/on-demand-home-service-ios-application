# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'pinwork' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for pinwork

pod 'IQKeyboardManager'
pod 'lottie-ios', '2.0.3'
pod 'Alamofire', '~> 4.7'
pod 'SwiftyJSON', '~> 4.0'
pod 'ReachabilitySwift'
pod 'BRYXBanner'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'HCSStarRatingView', '~> 1.5'
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
end
