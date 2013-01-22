module Metrognome
  class Railtie < Rails::Railtie
    railtie_name :metrognome

    rake_tasks do
      load "tasks/metrognome.rake"
    end
  end
end
