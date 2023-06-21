# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

target 'PDfMaker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PDfMaker
  pod 'LookinServer', :configurations => ['Debug']
  pod 'SnapKit'
  pod 'KRProgressHUD'
  pod 'SwifterSwift'
  pod 'SwiftyStoreKit'
  pod 'TPInAppReceipt'
  pod 'Masonry'
  pod 'YPImagePicker'
  pod 'DeviceKit'
end
