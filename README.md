# Mice

Mice is semantic front-end framework.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mice'
```
or

```ruby
gem 'mice', :git => 'git@github.com:miclle/mice.git'
```

And then execute:

`bundle install`

Or install it yourself as:

`$ gem install mice`


## mice with Rails

### CSS

Import Mice in an SCSS file (for example, `application.css.scss`) to get all of Mice's styles

```css
@import "mice";
```

or

```css
/*
 *= require mice
 */
```

For mobile
@import "mice-mobile"


## Documentation

Ratchet's documentation is built with [Middleman](http://middlemanapp.com/) and publicly hosted on GitHub Pages at <http://mice.miclle.com/>. The docs may also be run locally.

### Running documentation locally

1. If necessary, `gem install bundler`.
2. From the root `/mice` directory, run `bundle install`
3. Run `middleman server` in the command line.
3. Open <http://localhost:4567> in your browser, and boom!

Learn more about using Middleman by reading its [documentation](http://middlemanapp.com/basics/getting-started/).



## Contributing

1. Fork it ( http://github.com/miclle/mice/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and license

Code and documentation copyright 2014 Miclle. Code released under the MIT license. Docs released under Creative Commons.
