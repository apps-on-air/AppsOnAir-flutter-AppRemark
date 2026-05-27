#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appsonair_flutter_appremark.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appsonair_flutter_appremark'
  s.version          = '0.2.8'
  s.summary          = 'AppsOnAir AppRemark flutter sdk allows you to capture current screen on device shake.'
  s.description      = <<-DESC
AppsOnAir AppRemark flutter sdk allows you to capture current screen on device shake directly through AppsOnAir.
                       DESC
  s.homepage         = 'https://documentation.appsonair.com/category/appremark-beta'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'devtools-logicwind' => 'devtools@logicwind.com' }
  s.source           = { :path => '.' }
  # Source files live in the SPM layout directory (shared between CocoaPods and SPM)
  s.source_files     = 'appsonair_flutter_appremark/Sources/appsonair_flutter_appremark/**/*.{swift,h,m}'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  s.dependency 'AppsOnAir-AppRemark',  '1.1.2'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
