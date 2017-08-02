Pod::Spec.new do |s|
  s.name         = "ZZOperationExtension"
  s.version      = "0.3.9"
  s.summary      = "An extension to NSOperation."
  s.homepage     = "https://github.com/sablib/ZZOperationExtension"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "sablib" => "sablib.iak@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/sablib/ZZOperationExtension.git", :tag => s.version.to_s }
  s.source_files  = "Classes", "ZZOperationExtension/Classes/**/*.{h,m}"
end
