# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Wen' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Wen
	
pod 'Material', '~> 2.0'
pod 'GoogleAPIClient/Calendar', '~> 1.0.2'
pod 'Google/SignIn'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Graph'

  target 'WenTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  pod 'GradientCircularProgress', :git => 'https://github.com/keygx/GradientCircularProgress'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end

end
