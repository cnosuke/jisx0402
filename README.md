# Jisx0402

全国地方公共団体コード (JIS X 0402) を検索して扱うためのgemです。
元データは[こちら](http://www.soumu.go.jp/denshijiti/code.html)(総務省)。
(平成26年4月5日現在　※平成27年4月1日時点においても最新のもの)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jisx0402'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jisx0402

## Usage

```ruby
require 'jisx0402'

district = Jisx0402.search('しぶや') #=> #<Jisx0402::Code:0x007fbc522a3d00>
district.code #=> "131130"

district.prefecture #=> "東京都"
district.prefecture(hiragana: true) #=> "とうきょうと"

district.district #=> "渋谷区"
district.district(hiragana: true) #=> "しぶやく"

district.full #=> "東京都渋谷区"
district.full(hiragana: true) #=> "とうきょうとしぶやく"

Jisx0402.search('131130').full #=> "東京都渋谷区"

Jisx0402.search('青葉') #=> [#<Jisx0402::Code:0x007fbc533719e8>, #<Jisx0402::Code:0x007fbc533719c0>]
Jisx0402.search('青葉').map{|district| district.full } #=> ["宮城県仙台市青葉区", "神奈川県横浜市青葉区"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jisx0402. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
