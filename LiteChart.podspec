#
#  Be sure to run `pod spec lint LiteChart.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "LiteChart"
  spec.version      = "1.0.0"
  spec.summary      = "A lightweight data visualization chart framework for iOS platform. 轻量级的iOS图表可视化框架"

  spec.homepage     = "https://github.com/lmyl/LiteChart"

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  spec.author             = { "刘洋" => "1269458422ly@gamail.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = "13"
 
  spec.source       = { :git => "https://github.com/lmyl/LiteChart.git", :tag => spec.version }

  spec.source_files  = "Sources/**/*.swift"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  spec.framework  = "Foundation", "UIKit", "CoreGraphics"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.dependency "SnapKit", "~> 5.0"
  spec.swift_version = '5.0'
end
