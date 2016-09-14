

Pod::Spec.new do |s|

  s.name         = "UICircularProgressRing"
  s.version      = "0.1"
  s.summary      = "A circular progress bar for iOS written in Swift 3"


  s.description  = "A circular progress bar for iOS written in Swift 3"

  s.homepage     = "https://github.com/luispadron/UICircularProgressRing"


  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "Luis Padron" => "luispadronedu@gmail.com" }
  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/luispadron/UICircularProgressRing.git", :tag => "v0.1" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "UICircularProgressRing", "UICircularProgressRing/**/*.{h,m}"
end
