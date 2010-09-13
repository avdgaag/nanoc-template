class CacheBusterFilter < Nanoc3::Filter
  identifier :cache_buster

  def run(content, args = {})
    return content unless @site.config[:cache_busting]
    content.gsub(/(href|src)="([^"]+(\.(?:png|gif|js|jpg|css)))"/) do |m|
      real_path = File.join(File.dirname(__FILE__), '..', 'content', $2)
      if File.exists?(real_path)
        mtime = File.mtime(real_path).strftime('%Y%m%d%H%m')
        %Q{#{$1}="#{$2.sub($3, '-cb' + mtime + $3)}"}
      else
        m
      end
    end
  end
end
