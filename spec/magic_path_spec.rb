require 'spec_helper'

describe MagicPath do
  it 'has a version number' do
    expect(MagicPath::VERSION).not_to be nil
  end

  it 'allows creation of paths' do
    MagicPath.create_path :test_path, { pattern: 'foo/bar' }
    expect(MagicPath).to respond_to :test_path
  end

  it 'raises an error when trying to create the same path twice' do
    MagicPath.create_path :dup_path, { pattern: 'foo/bar' }
    expect {MagicPath.create_path( :dup_path, { pattern: 'foo/bar' })}.to raise_error(MagicPath::PathManager::AlreadyExistsError)
  end

  it 'provides accessors for created_paths' do
    MagicPath.create_path :acc_path, { pattern: 'foo/bar' }
    expect(MagicPath.acc_path.to_s).to eq 'foo/bar'
  end

  it 'allows redefining paths' do
    MagicPath.create_path :redef_path, { pattern: 'foo/bar' }
    MagicPath.redef_path = { pattern: 'foo/bar/baz' }
    expect(MagicPath.redef_path.to_s).to eq 'foo/bar/baz'
  end

end
