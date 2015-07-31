# VersionTracker

Add Version to your Rails Application.
Currently supported version format is *major.minor.patch*, i.e. `0.0.0`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'version_tracker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install version_tracker

## Usage

### Using Command Line
```
version [read]        # Display current VERSION
version init [value]  # Initialize VERSION File with provided value.
                      # Default: 0.0.0 if value is not provided and VERSION File does not exist
version bump [part]   # Bump VERSION based on part.
                      # Valid part: major, minor, patch (Default: patch)
version tag           # Tag using current VERSION

OPTIONS:
  -r, --release                    Push to release branch using current version
  -m, --message=MESSAGE            Push with custom commit message
  -p, --push                       Push to current branch
  -h, --help                       Help
```

### Using Rake Tasks
```ruby
rake version_tracker:initialize       # Initialize Version
rake version_tracker:current_version  # Read Version
rake version_tracker:bump_major       # Bump Major
rake version_tracker:bump_minor       # Bump Minor
rake version_tracker:bump_patch       # Bump Patch
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/version_tracker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
