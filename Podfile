use_frameworks!
platform :ios, '9.0'

target 'Rate-iOS' do
    pod 'Charts'
    pod 'AFNetworking'
    pod 'MJRefresh'
    pod 'UIImageView+Extension'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end
