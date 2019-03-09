# Rubelm

[![Build Status](https://img.shields.io/badge/status-in%20progress-yellow.svg)]()
[![Build Status](https://travis-ci.org/anharu2394/rubelm.svg?branch=master)](https://travis-ci.org/anharu2394/rubelm)
[![Tag Version](https://img.shields.io/github/tag/anharu2394/rubelm.svg)]()

*Rubelm* is A Opal library for building web applications.

Gem URL : https://rubygems.org/gems/rubelm

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opal-sprockets'
gem 'rubelm'
```

And then execute:

```
$ bundle
```

## Usage

Please run on your application directory.

```
$ mkdir app
$ touch app/app.rb config.ru
```

your application directory tree shoud be like this.
```
.
├── Gemfile
├── Gemfile.lock
├── app
│   └── app.rb
└── config
```
Please edit `config.ru`

```ruby
require 'bundler'
Bundler.require

run Opal::Sprockets::Server.new { |s|
  s.append_path 'app'
    s.debug = true
    s.main = 'app'
}
```

Please edit `app/app.rb`

```ruby
require "rubelm"
require "opal-browser"
include Rubelm::Html
view = div({class: "hello"},[
    div({class:"world"}, "hello, world!")
])
Rubelm::main(view,$document.body)
  ```

  Please run.

  ```
  $ bundle
  $ bundle exec rackup
  ```

  You can see on http://localhost:9292

  ![image](https://user-images.githubusercontent.com/26423094/53695378-53e4c580-3dfe-11e9-813d-31b7c72e509f.png)


## Contributing

  Bug reports and pull requests are welcome on GitHub at https://github.com/anharu2394/rubelm.
