require 'typogruby'
class TypogrubyFilter < Nanoc3::Filter
  identifier :typogruby
  def run(content, args = {})
    Typogruby.improve content
  end
end