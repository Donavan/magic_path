# Root namespace for our gem
module MagicPath
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
      @locked_path = nil
    end

    def resolve(extra_params = {})
      return @locked_path unless @locked_path.nil?
      full_params = @params.merge(extra_params)
      @pattern.split('/').map { |f| f[0] == ':' ? _var(f[1..-1], full_params) : f }.join('/')
    end

    def finalize(extra_params = {})
      @locked_path = resolve(extra_params)
    end

    def finalized?
      !@locked_path.nil?
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

    def to_s(extra_params = {})
      resolve extra_params
    end

    def to_str(extra_params = {})
      self.to_s extra_params
    end

    def rmdir(extra_params = {})
      Dir.rmdir resolve(extra_params)
    end

    def inspect
      "DynamicPath: #{@pattern}"
    end

    private

    def _var(var_name, full_params = {})
      return full_params[var_name] if full_params.key?(var_name)
      return full_params[var_name.to_sym] if full_params.key?(var_name.to_sym)
      #return Nenv.send(var_name) if Nenv.respond_to?(var_name)
      resolver = _resolver_for(var_name)
      return resolver.send(var_name) unless resolver.nil?
      raise ArgumentError, "Could not locate #{var_name}, in params or ENV."
    end

    def _resolver_for(var_name)
      MagicPath.resolvers.find { |r| r.respond_to?(var_name) }
    end
  end
end
