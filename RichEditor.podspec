#
# Be sure to run `pod lib lint RichEditor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name         = "RichEditor"
    s.version      = "0.0.1"
    s.summary      = "Summary."
    s.homepage     = "https://github.com/will-lumley/RichEditor.git"
    s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
    
    s.description      = <<-DESC
      Description.
                            DESC

    s.author             = { "William Lumley" => "will@lumley.io" }
    s.social_media_url   = "https://twitter.com/wlumley95"

    s.osx.deployment_target = "10.12"
    
    s.swift_version         = '5.0'
    
    s.source       = { :git => "https://github.com/will-lumley/RichEditor.git", :tag => s.version.to_s }
    
    s.source_files = 'Sources/**/*/*'
    
    s.dependency 'macColorPicker', '~> 1.2.1'
end
