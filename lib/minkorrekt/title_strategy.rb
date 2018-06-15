module Minkorrekt
  class TitleStrategy
    attr_reader :fallback, :matcher

    def initialize(matcher, fallback_title = '')
      @matcher = matcher
      @fallback = fallback_title
    end

    def title_from(string)
      matches = string.match(matcher)
      matches ? matches.captures[0] : fallback
    end
  end

  class ChinaGadgetTitleStrategy
    attr_reader :strategy, :episode

    def initialize(episode)
      @episode = episode
      @strategy = Minkorrekt::TitleStrategy.new(
        /chinagadget.*: (?:")?([ \wäöü-]+)/i,
        'Gab kein Chinagadget'
      )
    end

    def title
      strategy.title_from(episode.description)
    end
  end
end
