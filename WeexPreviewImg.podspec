# coding: utf-8
Pod::Spec.new do |s|
  s.name         = "WeexPreviewImg"
  s.version      = "1.0.0"
  s.summary      = "PreviewImg for Weex"
  s.homepage     = 'https://github.com/Vongolatt/WeexPreviewImg'
  s.license      = "MIT"
  s.authors      = { "Vongolatt" => "1085280247@qq.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source = { :git => 'https://github.com/Vongolatt/WeexPreviewImg', :tag => s.version.to_s }

  s.source_files = "Class/*.{h,m,mm}"
  s.dependency 'WeexSDK'
  s.dependency 'MBProgressHUD'
  s.requires_arc = true
end
