require 'net/http'
require 'uri'
require 'xmlrpc/client'

desc 'Notify verious services of the updated website'
task :ping => ['ping:sitemap', 'ping:pingomatic']

namespace :ping do
  task :sitemap do
    puts "Pinging Google Webmaster Tools"
    Net::HTTP.get(
        'www.google.com',
        '/webmasters/tools/ping?sitemap=' +
        URI.escape(File.join(config['base_url'], 'sitemap.xml'))
    )
  end

  task :pingomatic do
    puts "Pinging ping-o-matic"
    XMLRPC::Client.new('rpc.pingomatic.com', '/').call(
      'weblogUpdates.extendedPing',
      config['meta_data']['title'],
      config['base_url'],
      config['base_url'] + config['feed_url']
    )
  end
end

# Hook into the deploy task and always run ping afterwards
task :'deploy:rsync' do
  Rake::Task[:ping].invoke unless ENV['config'] == 'staging'
end
