module Minkorrekt
  class Episode
    def self.setup(experiment, china_gadget)
      @experiment = experiment
      @china_gadget = china_gadget
      self
    end

    def self.experiment
      @experiment
    end

    def self.china_gadget
      @china_gadget
    end

    attr_reader :title, :url, :summary, :description, :publication_date, :is_special, :experiment, :china_gadget

    def initialize(url, title, publication_date, summary, description)
      @url = url
      @title = title
      @summary = summary
      @description = description
      @publication_date = publication_date
      @is_special = false

      @experiment = self.class.experiment.new(self)
      @china_gadget = self.class.china_gadget.new(self)
    end

    def number
      matches = title.match(/Folge (\d+)/)
      if matches
        matches.captures[0]
      else
        is_special = true
        'Sonderfolge'
      end
    end

    def to_s
      "Titel: #{title}\n" +
      "URL: #{url}\n" +
      "Nummer: #{number}\n" +
      "Spezialfolge: #{is_special}\n" +
      "Veroeffentlichungsdatum: #{publication_date}\n" +
      "Experiment: #{experiment}\n\n"
    end
  end
end
