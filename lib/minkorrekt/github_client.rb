require 'pp'

module Minkorrekt
  class GithubClient
    def self.setup(backend, token)
      @client ||= backend.new(:access_token => token)
    end

    def self.client
      @client
    end

    def initialize
      @result = nil
    end

    def client
      self.class.client
    end

    def experiment_docs_available?(episode_id)
      search_experiment_docs(episode_id).total_count > 0
    end

    def experiment_docs_complete?(episode_id)
      experiment_docs_available?(episode_id) && !search_experiment_docs(episode_id).items.first.path.include?('todo')
    end

    def experiment_docs_url(episode_id)
      experiment_docs_available?(episode_id) ? search_experiment_docs(episode_id).items.first.html_url : ''
    end

    def experiment_docs_creation_base_url()
      "https://github.com/pajowu/minkorrekt-experimente/new/master"
    end

    def search_experiment_docs(episode_id)
      @result ||= client.search_code("repo:pajowu/minkorrekt-experimente extension:md filename:#{episode_id}")
    end
  end
end
