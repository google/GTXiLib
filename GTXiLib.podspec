Pod::Spec.new do |s|
  s.name         = "GTXiLib"
  s.version      = "2.0"
  s.summary      = "iOS Accessibility testing library."
  s.description  = <<-DESC
  iOS Accessibility testing library that works with XCTest based frameworks.
                   DESC
  s.homepage     = "https://github.com/google/GTXiLib"
  s.license      = "Apache License 2.0"
  s.author       = "j-sid"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/google/GTXiLib.git", :tag => "2.0.0" }
  s.source_files = "Classes/**/*.{h,m,swift}"
end
