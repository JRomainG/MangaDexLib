#
#  Be sure to run `pod spec lint MangaDexLib.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "MangaDexLib"
  spec.version      = "0.4"
  spec.summary      = "Cross-platform Swift framework to interact with the MangaDex website."
  spec.description  = <<-DESC
				   MangaDexLib is a cross-platform Swift framework to interact with the MangaDex website. Its goal is to offer a robust abstract interface to access the website's core features.
                   DESC

  spec.homepage     = "https://github.com/JRomainG/MangaDexLib"
  spec.license      = { :type => "GPLv3", :file => "LICENSE" }
  spec.author       = "Jean-Romain Garnier"
  spec.source       = { :git => "https://github.com/JRomainG/MangaDexLib.git", :tag => "v" + spec.version.to_s }

  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "10.10"
  spec.source_files   = "Sources/**/*.swift"
  spec.swift_versions = ["5.0", "5.1", "5.2"]

  spec.framework    = "WebKit"
  spec.dependency "SwiftSoup"
end
