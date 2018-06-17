module Minkorrekt
  class EpisodeExtractor
    attr_reader :feed_parser, :required_fields, :episode

    def initialize(feed_parser, episode)
      @feed_parser = feed_parser
      @episode = episode
      @required_fields = [:title, :link, :pubDate, :description, :encoded]
    end

    def generate_episode_models
      data = extract_episodes_fields(feed_parser.parse_episode_data, required_fields)
      episodes = []

      data.each do |x|
        episodes << episode.new(x[:link], x[:title], x[:pubDate], x[:description], x[:encoded])
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
