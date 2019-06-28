# Apply `pngcrush` to a file. Requires `pngcrush` to be in `$PATH`.
class PngcrushFilter < Nanoc::Filter
  identifier :pngcrush
  type :binary

  def run(filename, params = {})
    system "pngcrush -q -reduce -brute #{filename} #{output_filename}"
  end
end
