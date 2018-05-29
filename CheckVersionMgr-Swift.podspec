#
#  Be sure to run `pod spec lint CheckVersionMgr-Swift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CheckVersionMgr-Swift"
  s.version      = "0.0.1"
  s.summary      = "APP Version Check Manager."
  s.swift_version = "4.0"
  s.description  = <<-DESC
			APP 版本检查提示库,可设置两次提醒的间隔,跳转方式(inApp/App Store),支持自定义弹窗和系统弹窗两种提示方式
                   DESC
  s.homepage     = "https://github.com/xingfuqiu/CheckVersionMgr"
  s.license      = "MIT"
  s.author       = { "xingfuqiu" => "xingfuqiu@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/xingfuqiu/CheckVersionMgr.git", :tag => "#{s.version}" }
  s.source_files = "CheckVersionMgr/*.swift"
end
