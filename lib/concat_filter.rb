class ConcatFilter < Nanoc3::Filter
  identifier :concat

  def run(content, args = {})
    content.gsub(%r{^\s*(?:// require |@import url)\(?([a-zA-Z0-9_\-\.]+)(?:\);)?$}) do |m|
      load_file($1) || m
    end
  end

private

  def load_file(filename)
    path = File.join(File.dirname(__FILE__), '..', 'vendor', filename)
    return unless File.exists? path
    File.read(path)
  end
end
