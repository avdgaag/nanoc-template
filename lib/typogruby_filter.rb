require 'typogruby'

# A simple filter that processes an item's content with Typogruby, a text
# filter that improves HTML typography.
class TypogrubyFilter < Nanoc3::Filter
  identifier :typogruby
  def run(content, args = {})
    Typogruby.improve content
  end
end