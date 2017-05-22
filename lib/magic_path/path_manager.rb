require 'magic_path/dynamic_path'

module MagicPath
  class PathManager
    class Error < ArgumentError
    end

    class MethodError < Error
      def initialize(meth)
        @meth = meth
      end
    end

    class AlreadyExistsError < MethodError
      def message
        format('Path %s already exists', @meth.inspect)
      end
    end

    attr_writer :resolvers
    def resolvers
      @resolvers ||= default_resolvers
    end

    def default_resolvers
      defined?(Nenv) ? [Nenv] : []
    end

    def add_resolver(resolver)
      resolvers << resolver
    end

    def create_path(meth, opts)
      self.class._create_path_accessor(singleton_class, meth)
      send("#{meth}=", opts)
    end

    class << self
      def create_path(meth, opts)
        _create_path_accessor(self, meth, opts)
        send("#{meth}=", opts)
      end

      def _create_path_accessor(klass, meth)
        _fail_if_accessor_exists(klass, meth)
        _create_path_writer(klass, meth)
        _create_path_reader(klass, meth)
      end

      def _create_path_writer(klass, meth)
        klass.send(:define_method, "#{meth}=") do |opts|
          path = DynamicPath.new(opts[:pattern], opts[:params])
          klass.class_variable_set("@@#{meth}".to_sym, path)
        end
      end

      def _create_path_reader(klass, meth)
        klass.send(:define_method, meth.to_s.delete('=')) do
          klass.class_variable_get("@@#{meth}".to_sym)
        end
      end

      def _fail_if_accessor_exists(klass, meth)
        raise(AlreadyExistsError, meth) if klass.method_defined?(meth)
      end
    end
  end
end
