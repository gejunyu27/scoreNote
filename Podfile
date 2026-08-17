platform :ios, '15.0'

# Uncomment this line if you need Swift support:
inhibit_all_warnings!
use_frameworks!

# Inform CocoaPods that we use some custom build configurations
# Leave this in place unless you've tweaked the project's targets and configurations.
target 'scoreNote' do
  
  pod 'FMDB'
#  pod 'AFNetworking', '4.0.1'
#  pod 'YYKit', '1.0.9'
#  pod 'SDWebImage', '5.12.1'
#  pod 'SDCycleScrollView', '1.82'
#  pod 'MJRefresh', '3.7.5'
#  pod 'Masonry', '1.1.0'
#  pod 'YYModel', '1.0.4'
#  pod 'SVProgressHUD'
  pod 'IQKeyboardManager'
  pod 'AAChartKit'
end

# 强制统一所有Pods编译版本（关键）
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      # 同时关闭架构冗余警告（顺带优化）
      config.build_settings['VALID_ARCHS'] = 'arm64 x86_64'
    end
  end
end
