# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
def commonPods
  pod 'SnapKit'
  pod 'SwiftLint'
end

def reactivePods
  pod 'RxSwift'
  pod 'RxCocoa'
end

def testingPods
  pod 'Nimble'
  pod 'Quick'
  pod 'RxTest'
end

target 'Syscolabs-star-war-planet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  commonPods
  reactivePods
  
  # Pods for Syscolabs-star-war-planet

  target 'Syscolabs-star-war-planetTests' do
    inherit! :search_paths
    # Pods for testing
    testingPods
  end
end
