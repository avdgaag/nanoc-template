require 'bundler/setup'
require 'yaml'
require 'nanoc3/tasks'
Dir['tasks/*.rake'].each { |f| import f }

def config
  @config ||= YAML.load_file(File.join(File.dirname(__FILE__), 'config.yaml'))
end

