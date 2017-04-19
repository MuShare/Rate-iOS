use_frameworks!

target 'Rate-iOS' do
    pod 'Charts', '~> 3'
    pod 'AFNetworking', '~> 3'
    pod 'MJRefresh', '~> 3'
    pod 'UIImageView+Extension', '~> 0.2'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.1'
        end
    end
end
