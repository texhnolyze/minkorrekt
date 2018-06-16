require 'pp'

module Minkorrekt
  class GithubClient
    def self.setup(backend, token)
      @client ||= backend.new(:access_token => token)
      self
    end

    def self.client
      @client
    end

    def client
      self.class.client
    end

    def experiment_docs_available?(episode_id)
      !experiment_docs_view_url(episode_id).empty?
    end

    def experiment_docs_complete?(episode_id)
      !experiment_doc_from(episode_id, finished_experiment_docs).nil?
    end

    def experiment_docs_view_url(episode_id)
      experiment_docs = experiment_docs_in_progress.concat(finished_experiment_docs)
      doc = experiment_doc_from(episode_id, experiment_docs)
      doc ? doc.html_url : ''
    end

    def experiment_docs_edit_url(episode_id)
      experiment_docs_view_url(episode_id).gsub('blob', 'edit')
    end

    def experiment_docs_creation_base_url()
      "https://github.com/pajowu/minkorrekt-experimente/new/master"
    end

    def experiment_doc_from(episode_id, list)
      list.find { |doc| doc.name.eql?("#{episode_id}.md") }
    end

    def finished_experiment_docs()
      client.contents('pajowu/minkorrekt-experimente', { path: 'docs' })
    end

    def experiment_docs_in_progress()
      client.contents('pajowu/minkorrekt-experimente', { path: 'docs/todo' })
    end
  end
end
