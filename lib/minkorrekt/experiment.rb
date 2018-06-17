module Minkorrekt
  class Experiment
    def self.setup(title_strategy, description_strategy, github_client)
      @title_strategy = title_strategy
      @description_strategy = description_strategy
      @github_client = github_client
      self
    end

    def self.title_strategy
      @title_strategy
    end

    def self.description_strategy
      @description_strategy
    end

    def self.github_client
      @github_client
    end

    attr_reader :docs_id, :episode, :client, :title_strategy, :description_strategy

    def initialize(episode)
      @episode = episode
      @docs_id = episode.number.rjust(2, '0')

      @client = self.class.github_client.new
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
      link_tags = Nokogiri::HTML(description).xpath('//a')
      Hash[link_tags.map { |tag| [tag.text, tag.attr('href')] }]
    end

    def docs_view_url
      client.experiment_docs_view_url(docs_id)
    end

    def docs_edit_url
      client.experiment_docs_edit_url(docs_id)
    end

    def docs_creation_url
      base_url = client.experiment_docs_creation_base_url
      base_url + "?filename=#{CGI.escape("/docs/todo/#{docs_id}.md")}&value=#{CGI.escape(docs_creation_template)}"
    end

    def docs_creation_template
       <<~HEREDOC
         # #{title} ([Folge #{episode.number}](#{episode.url}))

         ## Benötigt wird

         ## Experiment
         #{description}

         ## Warum?

         ## Weitere Informationen
         #{external_links.map { |text, link| "- [#{text}](#{link})" }.join("\n")}
      HEREDOC
    end

    def docs_available?
      client.experiment_docs_available?(docs_id)
    end

    def docs_complete?
      client.experiment_docs_complete?(docs_id)
    end
  end
end
