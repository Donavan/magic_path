require 'magic_path/version'
require 'magic_path/dynamic_path'
# Root module for Magic Path
require 'magic_path/path_manager'
module MagicPath
  class << self
    def respond_to?(meth)
      instance.respond_to?(meth)
    end

    def method_missing(meth, *args)
      instance.send(meth, *args)
    end

    def reset
      @instance = nil
    end

    def instance
      @instance ||= MagicPath::PathManager.new
    end
  end
end
