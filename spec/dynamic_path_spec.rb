require 'spec_helper'
require 'pry'

module MagicPath
  describe MagicPath::DynamicPath do
    it 'Resolves path vars from the initial params hash' do
      path = DynamicPath.new('test_data/:initial_param/foo', {initial_param: 'test'})
      expect(path.resolve).to eq 'test_data/test/foo'
    end

    it 'Resolves path vars from the passed params hash' do
      path = DynamicPath.new('test_data/:passed_param/foo')
      expect(path.resolve({passed_param: 'test'})).to eq 'test_data/test/foo'
    end

    it 'Vars from the passed params hash override initial params' do
      path = DynamicPath.new('test_data/:updated_param/foo', {updated_param: 'foo'})
      expect(path.resolve({updated_param: 'test'})).to eq 'test_data/test/foo'
    end

    it 'Resolves path vars from the env' do
      Nenv.instance.create_method(:unit_env) {'test'}
      path = DynamicPath.new('test_data/:unit_env/foo')
      expect(path.resolve).to eq 'test_data/test/foo'
    end

    it 'Vars from the initial params hash override env params' do
      Nenv.instance.create_method(:unit_env) {'test'} unless Nenv.respond_to? :unit_env
      path = DynamicPath.new('test_data/:unit_env/foo', {unit_env: 'overridden'})
      expect(path.resolve).to eq 'test_data/overridden/foo'
    end

    it 'Vars from the passed params hash override env params' do
      Nenv.instance.create_method(:unit_env) {'test'} unless Nenv.respond_to? :unit_env
      path = DynamicPath.new('test_data/:unit_env/foo')
      expect(path.resolve({unit_env: 'overridden'})).to eq 'test_data/overridden/foo'
    end
  end
end
