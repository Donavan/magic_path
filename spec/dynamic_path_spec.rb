require 'spec_helper'
require 'nenv'
require 'pry'

module MagicPath
  describe MagicPath::DynamicPath do
    it 'Resolves path vars from the initial params hash' do
      path = DynamicPath.new('test_data/:initial_param/foo', initial_param: 'test')
      expect(path.resolve).to eq 'test_data/test/foo'
    end

    it 'Resolves path vars from the passed params hash' do
      path = DynamicPath.new('test_data/:passed_param/foo')
      expect(path.resolve(passed_param: 'test')).to eq 'test_data/test/foo'
    end

    it 'Includes Nenv in the default resolvers if it is already required' do
      expect(MagicPath.resolvers).to include(Nenv)
    end

    it 'Vars from the passed params hash override initial params' do
      path = DynamicPath.new('test_data/:updated_param/foo', updated_param: 'foo')
      expect(path.resolve(updated_param: 'test')).to eq 'test_data/test/foo'
    end

    it 'can be locked to a specific resolution' do
      path = DynamicPath.new('test_data/:updated_param/foo', updated_param: 'foo')
      path.finalize
      expect(path.resolve(updated_param: 'test')).to eq 'test_data/foo/foo'
    end

    it 'can tell if locked to a specific resolution' do
      path = DynamicPath.new('test_data/:updated_param/foo', updated_param: 'foo')
      path.finalize
      expect(path.finalized?).to be_truthy
    end

    it 'Resolves path vars from the resolvers' do
      Nenv.instance.create_method(:unit_env) { 'test' }
      path = DynamicPath.new('test_data/:unit_env/foo')
      expect(path.resolve).to eq 'test_data/test/foo'
    end

    it 'Vars from the initial params hash override resolver params' do
      Nenv.instance.create_method(:unit_env) { 'test' } unless Nenv.respond_to? :unit_env
      path = DynamicPath.new('test_data/:unit_env/foo', unit_env: 'overridden')
      expect(path.resolve).to eq 'test_data/overridden/foo'
    end

    it 'Vars from the passed params hash override resolver params' do
      Nenv.instance.create_method(:unit_env) { 'test' } unless Nenv.respond_to? :unit_env
      path = DynamicPath.new('test_data/:unit_env/foo')
      expect(path.resolve(unit_env: 'overridden')).to eq 'test_data/overridden/foo'
    end

    it 'can join a path to a filename' do
      path = DynamicPath.new('test_data/:unit_env/foo', unit_env: 'join')
      expect(path.join('data.yml')).to eq 'test_data/join/foo/data.yml'
    end

    it 'can create/remove a path on the disk, and tell you that it exists.' do
      path = DynamicPath.new('test_data/:unit_env/foo', unit_env: 'mkdir')
      path.mkdir_p
      expect(path.exist?).to be_truthy
      path.rmdir
      expect(path.exist?).to be_falsey
    end
  end
end
