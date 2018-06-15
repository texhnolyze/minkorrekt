

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

    experiment = Minkorrekt::Experiment.setup(
      Minkorrekt::ExperimentTitleStrategy,
      Minkorrekt::ExperimentDescriptionStrategy,
      github_client
    )
    china_gadget = Minkorrekt::ChinaGadget.setup(
      Minkorrekt::ChinaGadgetTitleStrategy,
      Minkorrekt::ChinaGadgetDescriptionStrategy
    )

    episode = Minkorrekt::Episode.setup(experiment, china_gadget)

    extractor = Minkorrekt::EpisodeExtractor.new(parser, episode)
    episodes = extractor.generate_episode_models

    episode = episodes[24]
    puts episode.title
    puts "\nExperiment:"
    puts episode.experiment.title
    puts episode.experiment.description
    puts "\nChinaGadget:"
    puts episode.china_gadget.title
    puts episode.china_gadget.description

    episode2 = episodes[63]
    puts episode2
    puts "\nExperiment:"
    puts episode2.experiment.title
    puts episode2.experiment.description
    puts "\nChinaGadget:"
    puts episode2.china_gadget.title
    puts episode2.china_gadget.description

    episode3 = episodes[87]
    puts episode3
    puts "\nExperiment:"
    puts episode3.experiment.title
    puts episode3.experiment.description
    puts "\nChinaGadget:"
    puts episode3.china_gadget.title
    puts episode3.china_gadget.description
  end

  module_function :setup
end
