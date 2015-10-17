Pod::Spec.new do |s|
    s.name                      = "RandomKit"
    s.version                   = "1.4.0"
    s.summary                   = "Random data generation in Swift."
    s.homepage                  = "https://github.com/nvzqz/RandomKit"
    s.license                   = { :type => "MIT", :file => "LICENSE.md" }
    s.author                    = "Nikolai Vazquez"
    s.ios.deployment_target     = "8.0"
    s.osx.deployment_target     = "10.9"
    s.watchos.deployment_target = '2.0'
    s.source                    = { :git => "https://github.com/nvzqz/RandomKit.git", :tag => "v#{s.version}" }
    s.source_files              = "RandomKit/*.swift"
end
