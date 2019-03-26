#
#  Be sure to run `pod spec lint ZVProgressHUD.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name          = "ZVProgressHUD"
  s.version       = "2.0.4"
  s.summary       = "A pure-swift and wieldy HUD "

  s.description  = <<-DESC
                   ZVProgressHUD a pure-swift and wieldy HUD 
                   DESC

  s.homepage     = "https://github.com/zevwings/ZVProgressHUD"
  s.license      = "MIT"
  s.author       = { "zevwings" => "zevwings@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zevwings/ZVProgressHUD.git", :tag => "#{s.version}" }
  s.source_files = "ZVProgressHUD/**/*.swift", "ZVProgressHUD/ZVProgressHUD.h"
  s.resources    = "ZVProgressHUD/Resource.bundle"
  s.requires_arc = true

  s.dependency 'ZVActivityIndicatorView'

end