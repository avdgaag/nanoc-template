require 'rainpress'
require 'jsmin'

# This filter can process javascript and stylesheet files and based on their
# extension it applies Rainpress or JSMin to its contents.
class MinifyFilter < Nanoc3::Filter
  identifier :minify
  def run(content, args = {})
    case @item[:extension]
    when 'css' then Rainpress.compress(content)
    when 'js' then JSMin.minify(content)
    else
      content
    end
  end
end
