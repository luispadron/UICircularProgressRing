Pod::Spec.new do |spec|
  spec.name         = "UICircularProgressRing"
  spec.version      = "8.0.0"
  spec.homepage     = "http://ucpr.luispadron.com"
  spec.summary      = "A highly customizable circular progress bar for iOS written in Swift"
  spec.description  = <<-DESC
  A highly customizable circular progress bar for iOS written in Swift, with Interface Builder support.
                      DESC
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.author             = { "Luis Padron" => "heyluispadron@gmail.com" }
  spec.ios.deployment_target = "10.0"
  spec.tvos.deployment_target = "10.0"
  spec.source       = { :git => "https://github.com/luispadron/UICircularProgressRing.git", :tag => "v#{spec.version}" }
  spec.source_files  = "Legacy", "Legacy/**/*.{h,m,swift}"
  spec.swift_version = '5.3'
end
