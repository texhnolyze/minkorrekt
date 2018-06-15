module Minkorrekt
  class DescriptionStrategy
    attr_reader :fallback, :matcher

    def initialize(matcher, fallback_title = '')
      @matcher = matcher
      @fallback = fallback_title
    end

    def description_from(string)
      matches = string.lines.select { |paragraph| paragraph.match(matcher) }
      if matches.empty?
        fallback
      else
        matches.last.strip
      end
    end
  end

  class ChinaGadgetDescriptionStrategy
    attr_reader :strategy, :episode

    def initialize(episode)
      @episode = episode
      @strategy = Minkorrekt::DescriptionStrategy.new(/china/i)
    end

    def description
      strategy.description_from(episode.description)
    end
  end

  class ExperimentDescriptionStrategy
    attr_reader :strategy,  :episode

    def initialize(episode)
      @episode = episode
      @strategy = Minkorrekt::DescriptionStrategy.new(
        /^(?!thema).*experiment.*$/i
      )
    end

    def description
      strategy.description_from(episode.description)
    end
  end
end
