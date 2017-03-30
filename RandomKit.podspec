Pod::Spec.new do |s|
    s.name                      = "RandomKit"
    s.version                   = "4.4.1"
    s.summary                   = "Random data generation in Swift."
    s.homepage                  = "https://github.com/nvzqz/#{s.name}"
    s.license                   = { :type => "MIT", :file => "LICENSE.md" }
    s.author                    = "Nikolai Vazquez"
    s.social_media_url          = "https://twitter.com/nikolaivazquez"
    s.ios.deployment_target     = "8.0"
    s.osx.deployment_target     = "10.9"
    s.watchos.deployment_target = '2.0'
    s.tvos.deployment_target    = '9.0'
    s.source                    = { :git => "https://github.com/nvzqz/#{s.name}.git", :tag => "v#{s.version}" }
    s.source_files              = "Sources/#{s.name}/**/*.swift"
    s.dependency "ShiftOperations"
end
