require 'rainpress'
require 'jsmin'

class MinifyFilter < Nanoc3::Filter
  identifier :minify
  def run(content, args = {})
    case @item[:extension]
    when 'css': Rainpress.compress(content)
    when 'js': JSMin.minify(content)
    else
      content
    end
  end
end
