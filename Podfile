# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


target 'Kash10' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Peko
  
  pod 'PhoneCountryCodePicker'
  pod 'IQKeyboardManagerSwift'
  pod 'KMPlaceholderTextView'
#  pod 'MKProgress'
  pod 'Alamofire'
  pod 'SDWebImage'
  # pod 'SDWebImageSVGCoder'
  pod 'Fastis'
  #pod 'CCBottomRefreshControl'
  pod 'ReachabilitySwift'
  pod 'FSCalendar'
  pod 'CodableFirebase'
  
  pod 'DapiBanking'
  pod 'NISdk'
  
  pod 'SwiftyStarRatingView'
  
  pod 'Cirque'
  
  pod 'SwiftyGif'
  pod 'lottie-ios'
  pod 'PureLayout'
  pod 'ParallaxHeader'
  pod 'WDScrollableSegmentedControl'
 
 pod 'SkeletonView'
 
 pod 'WARangeSlider'
 
 pod 'StripePaymentSheet'
 
 pod 'Bolt'
# pod 'CreditCardView'

  #pod 'UICircularProgressRing'
  
end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
