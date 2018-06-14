module Minkorrekt
  class EpisodeExtractor
    attr_reader :feed_parser, :required_fields

    def initialize(feed_parser)
      @feed_parser = feed_parser
      @required_fields = [:title, :link, :pubDate, :description, :encoded]
    end

    def generate_episode_models
      data = extract_episodes_fields(feed_parser.parse_episode_data, required_fields)
      episodes = []

      data.each do |x|
        episodes << Minkorrekt::Episode.new(x[:link], x[:title], x[:pubDate], x[:description], x[:encoded])
      end

      episodes
    end

    def extract_episodes_fields(episode_data, attributes)
      episode_data.map do |episode|
        episode_attr(episode, attributes)
      end
    end

    def episode_attr(episode, attributes)
      Hash[attributes.map { |a| [a,  attr_content(episode, a)] }]
    end

    def attr_content(node, attribute)
      node.xpath("./#{attribute.to_s}").text
    end
  end
end
