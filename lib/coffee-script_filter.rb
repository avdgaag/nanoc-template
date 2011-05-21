require 'coffee-script'

class CoffeescriptFilter < Nanoc3::Filter
  identifier :coffeescript

  def run(content, args = {})
    CoffeeScript.compile content
  end
end

