require 'bundler/setup'
require 'deadweight'
require 'xmlrpc/client'
require 'net/http'
require 'uri'
require 'yaml'
require 'nanoc3/tasks'

desc 'Notify verious services of the updated website'
task :ping => ['ping:sitemap', 'ping:pingomatic']

def config
  @config ||= YAML.load_file(File.join(File.dirname(__FILE__), 'config.yaml'))
end

Deadweight::RakeTask.new do |t|
  t.stylesheets = Dir['output/**/*.css'].map { |f| f.sub(/^output/, '') }
  t.pages = Dir['output/**/*.html'].map { |f| f.sub(/^output/, '') }
end

namespace :ping do
  task :sitemap do
    Net::HTTP.get(
        'www.google.com',
        '/webmasters/tools/ping?sitemap=' +
        URI.escape(File.join(config['base_url'], 'sitemap.xml'))
    )
  end

  task :pingomatic do
    XMLRPC::Client.new('rpc.pingomatic.com', '/').call(
      'weblogUpdates.extendedPing',
      config[:meta_data][:title],
      config[:base_url],
      config[:base_url] + '/atom.xml'
    )
  end
end