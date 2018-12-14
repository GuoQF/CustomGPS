#
#  Be sure to run `pod spec lint CustomGPS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.name         = "CustomGPS"
s.version      = "0.0.3"
s.summary      = "change your local location"
s.description  = 'change local gps and a simple systerm location help to use'
s.homepage     = "https://github.com/GuoQF/CustomGPS.git"

# ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.license      = "MIT"

# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.author             = "guoqf"
s.ios.deployment_target = "8.0"

# ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.source       = { :git => "https://github.com/GuoQF/CustomGPS.git", :tag => "#{s.version}" }

# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.source_files  = "CustomGPS", "CustomGPS/**/*.{h,m,gpx,txt}"
s.exclude_files = "CustomGPS/Exclude"

end
