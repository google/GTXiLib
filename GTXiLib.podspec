Pod::Spec.new do |s|
  s.name         = "GTXiLib"
  s.version      = "4.2"
  s.summary      = "iOS Accessibility testing library."
  s.description  = <<-DESC
  iOS Accessibility testing library that works with XCTest based frameworks.
                   DESC
  s.homepage     = "https://github.com/google/GTXiLib"
  s.license      = "Apache License 2.0"
  s.author       = "j-sid"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/google/GTXiLib.git", :tag => "4.2.0" }
  s.source_files = "{Classes,OOPClasses}/**/*.{h,m,swift,mm,cc}"
  s.ios.deployment_target = '9.0'
  s.libraries = 'c++'
  s.dependency 'Protobuf-C++'
end
