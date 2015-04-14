Pod::Spec.new do |s|
  s.name = 'Queue'
  s.version = '1.1.1'
  s.license = 'MIT'
  s.summary = 'A simple wrapper for dispatch queues in Swift'
  s.homepage = 'https://github.com/dmgctrl/Queue-Swift'
  s.authors = { 'Tonic Design' => 'info@tonicdesign.com' }
  s.source = { :git => 'https://github.com/dmgctrl/Queue-Swift.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Queue/*.swift'

  s.requires_arc = true
end
