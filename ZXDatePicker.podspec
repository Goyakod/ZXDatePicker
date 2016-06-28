
Pod::Spec.new do |s|

  s.name         = "ZXDatePicker"
  
  s.version      = "0.0.3"

  s.summary      = "A sample datePicker."
 
  s.homepage     = "https://github.com/Goyakod/ZXDatePicker"
 
  #s.license      = "MIT"
 
  s.author       = { "Goyakod" => "635214208@qq.com" }

  s.source       = { :git => "https://github.com/Goyakod/ZXDatePicker.git", :tag => "0.0.3" }

  s.source_files  =  "ZXDatePicker/**/*.{h,m}"

  s.framework  = "UIKit"

  s.platform     = :ios, "7.0"

end
