require "zeitwerk"
require "avo"
require "avo/dashboards/version"
require "avo/dashboards/engine"

loader = Zeitwerk::Loader.for_gem_extension(Avo)
loader.setup

module Avo
  module Dashboards
    # Your code goes here...
  end
end

loader.eager_load
