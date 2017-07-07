Pod::Spec.new do |s|
  s.name         = "STNavigationBar"
  s.version      = "0.1.0"
  s.summary      = "一行代码设置状态栏样式和导航栏背景颜色、标题、按钮、透明度以及全屏pop手势支持"
  s.homepage     = "https://github.com/LZAscott/STNavigationBar"
  s.license      = "MIT"
  s.author             = { "Scott_Mr" => "a632845514@vip.qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LZAscott/STNavigationBar.git", :tag => s.version }

  s.source_files  = "STNavigationBar", "STNavigationBar/*.{h,m}"
  s.requires_arc = true

end
