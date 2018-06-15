

module Minkorrekt
  require 'octokit'
  require 'nokogiri'
  require 'open-uri'

  require_relative 'minkorrekt/feed_parser'
  require_relative 'minkorrekt/episode_extractor'
  require_relative 'minkorrekt/episode'
  require_relative 'minkorrekt/experiment'
  require_relative 'minkorrekt/china_gadget'
  require_relative 'minkorrekt/github_client'
  require_relative 'minkorrekt/title_strategy'
  require_relative 'minkorrekt/description_strategy'

  def setup(feed_uri = 'http://minkorrekt.de/feed/mp3/')
    github_backend = Octokit::Client
    github_oauth_token = ENV['GITHUB_OAUTH_TOKEN']
    github_client = Minkorrekt::GithubClient.setup(
      github_backend,
      github_oauth_token
    )

    parser = Minkorrekt::FeedParser.new(feed_uri)

    experiment = Minkorrekt::Experiment
    china_gadget = Minkorrekt::ChinaGadget.setup(
      Minkorrekt::ChinaGadgetTitleStrategy,
      Minkorrekt::ChinaGadgetDescriptionStrategy
    )

    episode = Minkorrekt::Episode.setup(experiment, china_gadget)

    extractor = Minkorrekt::EpisodeExtractor.new(parser, episode)
    episodes = extractor.generate_episode_models

    episode = episodes[24]
    puts episode.china_gadget.title
    puts episode.china_gadget.description
    puts episode.china_gadget.external_links
  end

  module_function :setup
end
