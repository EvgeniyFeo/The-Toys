# Uncomment the next line to define a global platform for your project
  platform :ios, '14.4'

target 'The Toys' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

    pod 'Firebase/Auth', '~> 6.0'
    pod 'Firebase/Firestore', '~> 6.0'
    pod 'Firebase/Storage', '~> 6.0'
    pod 'FirebaseUI/Storage', '~> 8.0'

  # Pods for The Toys

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.4'
    end
  end
end