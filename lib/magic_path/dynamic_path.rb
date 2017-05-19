# Root namespace for our gem
module MagicPath
  require 'nenv'

  # A class to dynamically build paths based on parameters
  # Constructed with a pattern like: /test_data/:product/:state/:env
  # Each string beginning with a colon will be replaced from either
  # the params hash passed to the initializer, the "extra_params" hash passed to resolve
  # or environment variables (via Nenv).
  # extra_params is merged into the instance level params hash before resolution
  class DynamicPath
    attr_accessor :params
    attr_reader :pattern

    def initialize(pattern, params = {})
      @params = params || {}
      @pattern = pattern
    end

    def resolve(extra_params = {})
      full_params = @params.merge(extra_params)
      @pattern.split('/').map { |f| f[0] == ':' ? _var(f[1..-1], full_params) : f }.join('/')
    end

    def exist?(extra_params = {})
      File.exist? resolve(extra_params)
    end

    def mkdir_p(extra_params = {})
      FileUtils.mkdir_p resolve(extra_params)
    end

    def pathname(extra_params = {})
      Pathname.new resolve(extra_params)
    end

    def join(filename, extra_params = {})
      File.join(resolve(extra_params), filename)
    end

    def to_s
      resolve
    end

    def inspect
      "DynamicPath: #{@pattern}"
    end

    private

    def _var(var_name, full_params = {})
      return full_params[var_name] if full_params.key?(var_name)
      return full_params[var_name.to_sym] if full_params.key?(var_name.to_sym)
      return Nenv.send(var_name) if Nenv.respond_to?(var_name)
      raise ArgumentError, "Could not locate #{var_name}, in params or ENV."
    end
  end
end
