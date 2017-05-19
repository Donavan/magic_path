# magic_path
A gem for dynamic file paths. Paths can be defined using strings with variable substitution.  i.e. 'fixtures/:product/:state".  When the path is resolved into a string any part that begins with a colon will be replaced with it's value from a params hash or resolver object.



# Installation

Add this line to your application's Gemfile:

```ruby
gem 'magic_path'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magic_path

## Usage

### Define a path and pass params to resolve
```ruby
# Create our path
MagicPath.create_path :my_path, { pattern: 'data/:state/fixtures' }

# use the path
MagicPath.my_path.resolve { state: 'ohio' }
# /data/ohio/fixtures
```

### Define a path using initial params
```ruby
# Create our path
MagicPath.create_path :my_path, { pattern: 'data/:state/:product/fixtures', params: { product: 'foobar' } }

# use the path
MagicPath.my_path.resolve { state: 'ohio' }
# /data/ohio/foobar/fixtures
```

### Define a path using enviroment variables (via Nenv)
```ruby
require 'Nenv' 

# Create our path
MagicPath.create_path :my_path, { pattern: 'data/:test_env/fixtures' }

# use the path (Assuming test_env has been set to "test" in the environment)
MagicPath.my_path.to_s # to_s is the same as calling resolve without an aditional params hash.
# /data/test/fixtures
```

## Resolvers
A resolver is a simply an object that can respond to a variable name.  You can create your own and add the to MagicPath like so:

```ruby
class MyResolver
  def test_env
    "test"
  end
end

# Create our path
MagicPath.create_path :my_path, { pattern: 'data/:test_env/fixtures' }
MagicPath.add_resolver MyResolver.new
MagicPath.my_path.to_s # to_s is the same as calling resolve without an aditional params hash.
# /data/test/fixtures
```

If Nenv has already been required by your code, it will be automatically used as a resolver.  
