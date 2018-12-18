Pod::Spec.new do |s|
  s.name         = "Graver"
  s.version      = "0.1"
  s.summary      = "Graver for apps within waimai C"
# homepage地址暂时指向内部stash，开源之前改成github公网地址
  s.homepage     = "http://git.sankuai.com/projects/WM/repos/ios_c_graver/browse"
  s.license      = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author       = { "chenhang" => "chenhang03@meituan.com", "songyangyang" => "songyangyang03@meituan.com" }
  s.platform     = :ios, "9.0"
# source地址暂时指向内部stash，开源之前改成github公网地址
  s.source       = { :git => "ssh://git@git.sankuai.com/wm/ios_c_graver.git", :tag => "#{s.version}" }
  s.source_files  = "Graver", "Graver/**/*.{h,m}"
  s.preserve_paths = '*.pch'
  s.prefix_header_file = 'Graver.pch'
  s.requires_arc = true

  s.dependency 'SDWebImage', '4.2.1'
end
