module Avo
  module Dashboards
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
