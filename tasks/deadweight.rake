require 'deadweight'

Deadweight::RakeTask.new do |t|
  t.stylesheets = Dir[File.join(config['output_dir'], '**', '*.css')].map { |f| f.sub(/^#{config['output_dir']}/, '') }
  t.pages = Dir[File.join(config['output_dir'], '**', '*.html')].map { |f| f.sub(/^#{config['output_dir']}/, '') }
end
