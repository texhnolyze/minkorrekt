module Minkorrekt
  class MustacheRenderer < Mustache
    self.template_path = File.expand_path('../../../templates', __dir__)

    def render_experiments(episodes)
      render_file('experiments-list', { episodes: episodes })
    end
  end
end
