Pod::Spec.new do |s|
  s.name             = 'AWSLocations'
  s.version          = '1.0'
  s.summary          = 'AWSLocations'
  s.description      = <<-DESC 
	TODO: Location utilities
DESC

  s.homepage         = 'https://github.com/mawshd/AWSLocations'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Awais Shahid' => 'mawshd@gmail.com' }
  s.source           = { :git => 'https://github.com/mawshd/AWSLocations', :tag => "#{s.version}" }
  
  s.ios.deployment_target = '11.0'

  s.source_files = 'AWSCore/Core/**/*.{h,m,swift}'

  s.static_framework = true
  s.dependency 'GoogleMaps'
  
end
