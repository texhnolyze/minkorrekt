module Minkorrekt
  class FileExporter
    require 'fileutils'

    attr_reader :save_path

    def initialize(save_path)
      @save_path = save_path
    end

    def export(content, file_name)
      setup_save_dir
      File.write("#{save_path}/#{file_name}", content)
    end

    def setup_save_dir
      FileUtils::mkdir_p(save_path) unless File.exists?(save_path)
    end
  end
end
