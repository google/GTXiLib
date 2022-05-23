Pod::Spec.new do |s|
  s.name         = "GTXiLib"
  s.version      = "5.0"
  s.summary      = "iOS Accessibility testing library."
  s.description  = <<-DESC
  iOS Accessibility testing library that works with XCTest based frameworks.
                   DESC
  s.homepage     = "https://github.com/google/GTXiLib"
  s.license      = "Apache License 2.0"
  s.author       = "j-sid"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/google/GTXiLib.git", :tag => "5.0.0" }
  s.subspec "GTXiLib" do |sp|
    sp.source_files = "{Classes,OOPClasses}/**/*.{h,m,swift,mm,cc}"
    sp.public_header_files = "{Classes,OOPClasses}/**/*.h"
    sp.private_header_files = [
      "Classes/GTXImageRGBAData+GTXOOPAdditions.h",
      "Classes/GTXToolKit+GTXOOPAdditions.h",
      "Classes/NSObject+GTXAdditions.h",
      "Classes/NSString+GTXAdditions.h",
      "Classes/UIColor+GTXOOPAdditions.h"
    ]
    sp.exclude_files = ["Classes/XCTest/*.{h,m,mm}"]
    sp.resources = ["ios_translations.bundle"]
    sp.ios.deployment_target = "9.0"
    sp.ios.framework = "Vision"
    sp.libraries = "c++"
    sp.dependency "abseil"
    sp.dependency "tinyxml"
  end
  s.subspec "XCTestLib" do |sp|
    sp.source_files = "Classes/XCTest/*.{h,m,swift,mm,cc}"
    sp.public_header_files = "Classes/XCTest/*.h"
    sp.ios.framework = "XCTest"
    sp.dependency "GTXiLib/GTXiLib"
  end
  s.default_subspec = "GTXiLib"
end
