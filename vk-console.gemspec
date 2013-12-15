# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)
require  'vk-console'

Gem::Specification.new do |gem|
  gem.name = "vk-console"
  gem.version = VK::Console::VERSION
  gem.authors = ["Andrew Zinenko"]
  gem.email = "zinenkoan@gmail.com"
  gem.summary = "Ruby console for vk.com API"
  gem.description = " Ruby console for vk.com API "
  gem.homepage = "http://github.com/zinenko/vk-console"
  gem.date = Time.now.strftime '%Y-%m-%d'
  gem.licenses = ["MIT"]
    
  gem.extra_rdoc_files = ["LICENSE.txt", "README.md" ]
      
  gem.add_runtime_dependency 'vk-ruby', '>= 0.7.4', '= 0.9.3'
  gem.add_runtime_dependency 'mechanize', '~> 2.1.1'

  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')

  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- tests/*`.split("\n") 
end
