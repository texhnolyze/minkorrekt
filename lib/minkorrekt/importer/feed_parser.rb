module Minkorrekt
  class FeedParser
    attr_reader :feed_uri

    def initialize(feed_uri)
      @feed_uri = feed_uri
    end

    def parse
      result = Nokogiri::XML(open(feed_uri))
      result.remove_namespaces!
      result
    end

    def parse_episode_data
      parse.xpath('//channel/item')
    end
  end
end
