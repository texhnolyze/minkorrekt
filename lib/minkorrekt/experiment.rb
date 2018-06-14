module Minkorrekt
  class Experiment
    attr_reader :docs_id, :episode, :client

    def initialize(episode)
      @episode = episode
      @docs_id = episode.number.rjust(2, '0')
      @client = Minkorrekt::GithubClient.new
    end

    def title
      matches = episode.summary.match(/Experiment der Woche: (?:")?([ \wäöü-]+)/)
      matches ? matches.captures[0] : 'Gab kein Experiment'
    end

    def description
      if defined?(@description)
        @description
      else
        desc = episode.description.lines.select do |paragraph|
          paragraph.match(/Experiment/) && !paragraph.match(/Thema \d/)
        end

        @description = desc.last || ''
        @description.strip!
      end
    end

    def external_links
      link_tags = Nokogiri::HTML(description).xpath('//a')
      Hash[link_tags.map { |tag| [tag.text, tag.attr('href')] }]
    end

    def docs_view_url
      client.experiment_docs_url(docs_id)
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

    def to_s
      "Experiment Id: #{docs_id}\n" +
      "Experiment Titel: #{title}\n" +
      "Experiment Links: #{external_links}\n" +
      "Experiment Beschreibung: #{description}\n" +
      "Experiment Anleitung verfuegbar: #{docs_available?}\n" +
      "Experiment Anleitung vollstaendig: #{docs_complete?}\n" +
      "Experiment Anleitung url: #{docs_view_url}\n" +
      "Experiment Anleitung hinzufuegen url: #{docs_creation_url}\n"
    end
  end
end