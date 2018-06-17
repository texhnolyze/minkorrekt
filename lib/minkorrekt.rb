module Minkorrekt
  require 'octokit'
  require 'faraday-http-cache'
  require 'nokogiri'
  require 'mustache'

  require_relative 'minkorrekt/importer/feed_parser'
  require_relative 'minkorrekt/importer/episode_extractor'

  require_relative 'minkorrekt/model/episode'
  require_relative 'minkorrekt/model/experiment'
  require_relative 'minkorrekt/model/china_gadget'
  require_relative 'minkorrekt/model/description_strategy'
  require_relative 'minkorrekt/model/title_strategy'

  require_relative 'minkorrekt/github_client'

  require_relative 'minkorrekt/exporter/file_exporter'
  require_relative 'minkorrekt/renderer/mustache_renderer'

  module_function

  def setup(feed_uri = 'http://minkorrekt.de/feed/mp3/')
    episodes = episode_importer(feed_uri).generate_episode_models

    renderer = Minkorrekt::MustacheRenderer.new
    output = renderer.render_experiments(episodes)

    exporter = Minkorrekt::FileExporter.new(File.expand_path('../output/', __dir__))
    exporter.export(output, 'experiments-list.md')
  end

  def github_client
    stack = Faraday::RackBuilder.new do |builder|
      builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end
    Octokit.middleware = stack

    github_backend = Octokit::Client
    github_oauth_token = ENV['GITHUB_OAUTH_TOKEN']

    Minkorrekt::GithubClient.setup(
      github_backend,
      github_oauth_token
    )
  end

  def episode_importer(uri)
    parser = Minkorrekt::FeedParser.new(uri)
    Minkorrekt::EpisodeExtractor.new(parser, episode)
  end

  def episode
    Minkorrekt::Episode.setup(experiment, china_gadget)
  end

  def experiment
    Minkorrekt::Experiment.setup(
      Minkorrekt::ExperimentTitleStrategy,
      Minkorrekt::ExperimentDescriptionStrategy,
      github_client
    )
  end

  def china_gadget
    Minkorrekt::ChinaGadget.setup(
      Minkorrekt::ChinaGadgetTitleStrategy,
      Minkorrekt::ChinaGadgetDescriptionStrategy
    )
  end
end
