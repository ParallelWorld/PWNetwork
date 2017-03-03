Pod::Spec.new do |s|
  s.name         = "PWNetwork"
  s.version      = "0.0.1"
  s.summary      = "network组件库"
  s.description  = <<-DESC
    network组件库
                   DESC
  s.homepage     = "https://github.com/parallelWorld/PWNetwork"
  s.author       = { "Parallel World" => "654269765@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/parallelWorld/PWNetwork.git", :tag => "#{s.version}" }
  s.source_files = "PWNetwork/**/*.{h,m}"
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.1.0"
end

