module Minkorrekt
  class ChinaGadget
    def self.setup(title_strategy, description_strategy)
      @title_strategy = title_strategy
      @description_strategy = description_strategy
      self
    end

    def self.title_strategy
      @title_strategy
    end

    def self.description_strategy
      @description_strategy
    end

    attr_reader :episode, :title_strategy, :description_strategy

    def initialize(episode)
      @episode = episode
      @title_strategy = self.class.title_strategy.new(episode)
      @description_strategy = self.class.description_strategy.new(episode)
    end

    def title
      title_strategy.title
    end

    def description
      description_strategy.description
    end

    def external_links
      URI::Parser.new.extract(description, ['http', 'https'])
    end

    def docs_creation_template
       <<~HEREDOC
         # #{title} ([Folge #{episode.number}](#{episode.url}))

         ## Beschreibung
         #{description}

         ## Weitere Informationen
         #{external_links.join("\n\n")}
      HEREDOC
    end
  end
end
