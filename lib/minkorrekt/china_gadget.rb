module Minkorrekt
  class ChinaGadget
    attr_reader :episode

    def initialize(episode)
      @episode = episode
    end

    def title
      matches = episode.summary.match(/chinagadget: (?:")?([ \wäöü-]+)/i)
      matches ? matches.captures[0] : 'Gab kein Chinagadget'
    end

    def description
      if defined?(@description)
        @description
      else
        desc = episode.description.lines.select do |paragraph|
          paragraph.match(/china/i) && !paragraph.match(/Thema \d/)
        end

        @description = desc.last || ''
        @description.strip!
      end
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
