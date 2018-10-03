
Pod::Spec.new do |s|

  s.name         = "UICircularProgressRing"
  s.version      = "4.1.0"
  s.summary      = "A highly customizable circular progress bar for iOS written in Swift"

  s.description  = <<-DESC
  A highly customizable circular progress bar for iOS written in Swift, with Interface Builder support.
                   DESC

  s.homepage     = "https://github.com/luispadron/UICircularProgressRing"
  s.screenshots  = "https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/.github/banner.png", "https://raw.githubusercontent.com/luispadron/UICircularProgressRing/master/.github/demo.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Luis Padron" => "heyluispadron@gmail.com" }
  s.social_media_url   = "https://luispadron.com"

  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/luispadron/UICircularProgressRing.git", :tag => "v#{s.version}" }

  s.source_files  = "src/UICircularProgressRing", "src/UICircularProgressRing/**/*.{h,m}"
end
