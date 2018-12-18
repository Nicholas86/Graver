Pod::Spec.new do |s|
  s.name         = "Graver"
  s.version      = "1.0.0"
  s.summary      = "Graver for apps within waimai C"
  s.homepage     = "https://github.com/meituan-dianping/Graver"
  s.license      = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author       = { "chenhang" => "hangisnice@gmail.com", "songyangyang" => "493912271@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/meituan-dianping/Graver.git", :tag => "#{s.version}" }
  s.source_files  = "Graver", "Graver/**/*.{h,m}"
  s.preserve_paths = '*.pch'
  s.prefix_header_file = 'Graver.pch'
  s.requires_arc = true

  s.dependency 'SDWebImage', '4.2.1'
end
