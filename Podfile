# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'StudySwift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  #root
  pod 'RxSwift' 
  pod 'RxCocoa'
  pod 'Alamofire' 
  pod 'Moya/RxSwift'
  pod 'Moya-ObjectMapper'
  pod 'Result' 
  pod 'Kingfisher'
  pod 'SnapKit'
  pod 'SwiftyJSON'

  #tool
  pod 'R.swift'
  pod 'URLNavigator'
  pod 'RxDataSources'
  pod 'Then'
  pod 'EmptyDataSet-Swift'
  pod 'MBProgressHUD'
  pod 'MJRefresh'
  pod 'Toast-Swift'
  pod 'SwiftDate'
  pod 'CryptoSwift'

  # rxSwift 扩展
  pod 'RxSwiftExt'
  pod 'NSObject+Rx'
  pod 'RxGesture'
  pod 'RxOptional'

  # Pods for StudySwift
  
  # Debug RxSwift 必要配置
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          if target.name == 'RxSwift'
              target.build_configurations.each do |config|
                  if config.name == 'Debug'
                      config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                  end
              end
          end
      end
  end
  
  target 'StudySwiftTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'StudySwiftUITests' do
    # Pods for testing
  end

end
