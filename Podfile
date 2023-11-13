# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'AdwrLak' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for AdwrLak
    
    #Facebook login
    pod 'FBSDKCoreKit'
    pod 'FBSDKShareKit'
    pod 'FBSDKLoginKit'
    
    #Google Login With Firebase
    pod 'GoogleSignIn'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
    pod 'GoogleAnalytics'
    pod 'Firebase/Analytics'
    pod 'Firebase/Crashlytics'
    # IQKeyboardManager
    pod 'IQKeyboardManagerSwift'
    
    #Activity Indicator View
    pod 'NVActivityIndicatorView'
    
    #For Side Menu
    pod 'SlideMenuControllerSwift'
    
    #Network
    pod 'Alamofire'
    
    #Bar Button View
    pod 'XLPagerTabStrip', '~> 8.1'
    
    # Star control
    pod 'Cosmos'
    
    #TextField Effects
    pod "TextFieldEffects"
    
    # DropDown Menu
    pod 'DropDown'
    
    #Device Identification
    pod 'DeviceKit'
    
    #For Search Places
    pod 'GooglePlaces'
    pod 'GooglePlacePicker' 
    pod 'GoogleMaps'    
    
    #Image Cache
    pod 'SDWebImage'
    
    #Youtube Video Player
    #pod 'YouTubePlayer'
    
    #For Image Sliding
    pod 'ImageSlideshow'
    pod "ImageSlideshow/Alamofire"
    
    #Rich Text Editor
    #pod "RichEditorView"
    
    #Gallery Image Picker
    pod 'OpalImagePicker'
    
    #ProgressBar
    pod 'RangeSeekSlider'
    
    #AdMob
    pod 'Google-Mobile-Ads-SDK'
    #pod 'PersonalizedAdConsent'
    
    #In App Purchases
    pod 'SwiftyStoreKit'
    
    #Textfield Shake
    pod 'UITextField+Shake'
    
    #Push Notification
    pod 'NotificationBannerSwift'
    
    #Show Action Sheet
    #pod 'ActionSheetPicker-3.0'
    
    #Picker Library
    # pod 'TCPickerView'
    
    #Message Kit
    # pod 'MessageKit'
    # pod 'MessageInputBar'
    #pod 'JSQMessagesViewController', '7.3.3'
    
    pod 'SwiftCheckboxDialog'
    pod 'JGProgressHUD'

    #Play Gif 
    source 'https://github.com/CocoaPods/Specs.git'
    pod 'SwiftyGif'
    pod 'Popover'
    
    
    pod 'MapboxGeocoder.swift', '~> 0.11'
    #pod 'Mapbox-iOS-SDK', '~> 5.4'
    pod 'Alamofire-SwiftyJSON'
     
    #Intro App
    pod 'OnboardKit'
     #pod 'LinkedinSwift'
#pod 'LinkedinSwift', '>= 1.7.9'

pod "YoutubePlayer-in-WKWebView", "~> 0.3.0"
pod 'SOTabBar'
pod 'FSPagerView'
#pod 'FanMenu'
pod "ZGTooltipView"
pod 'CollageView', '~> 1.0.4'
    #Socket
    pod 'Socket.IO-Client-Swift', '~> 15.2.0'
    #progressBar
    pod 'MaterialProgressBar'
    #SLiderImages
pod "ZoomableImageSlider"
  #carousel
#pod "CLabsImageSlider", '~> 0.1.2'
#pod 'ZCycleView'
end


post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
             end
        end
    end
  
    
    
    
    installer.pods_project.targets.each do |target|
      # Make it build with XCode 15
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
      
      if ['SwiftyGif'].include? target.name
              target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
              end
      end
      # Make it work with GoogleDataTransport
      if target.name.start_with? "GoogleDataTransport"
        target.build_configurations.each do |config|
          config.build_settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'NO'
        end
      end
    end
  end
