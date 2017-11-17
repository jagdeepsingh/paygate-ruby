# paygate-ruby

`paygate-ruby` is a simple Ruby wrapper for [PayGate payment gateway](http://www.paygate.net/)'s OpenPayAPI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paygate-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paygate-ruby

## Usage

To start making the transactions on PayGate, you will need a Member ID and a Secret, for which you can register [here](https://admin.paygate.net/front/regist/registMember.jsp?lang=us).

After a successful registration, you will have access to the [dashboard](https://admin.paygate.net/front/board/welcome.jsp).

Now, initialize a `Paygate::Member` instance using the Member ID and Secret you generated above.

```ruby
member = Paygate::Member.new('testmid', 'secret')
 => #<Paygate::Member:0x007f96bdb70f38 @mid="testmid", @secret="secret">
```

The `member` responds to methods `mid`, and `secret`.

```ruby
member.mid
 => "testmid"

member.secret
 => "secret"
```

### Cancel a transaction

```ruby
response = member.cancel_transaction('testmid_123456.654321', amount: 1000)
 => #<Paygate::Response:0x007ff929351f90 @transaction_type=:cancel, @http_code="200", @message="OK", @body="callback({\"replyCode\":\"0000\",\"replyMessage\":\"Response has been completed\",\"content\":{\"object\":\"tid testmid_123456.654321 was canceled before.\"}})", @json={"replyCode"=>"0000", "replyMessage"=>"Response has been completed", "content"=>{"object"=>"tid testmid_123456.654321 was canceled before."}}>
```

Here, _testmid_123456.654321_ is `tid` of the transaction you want to cancel.

`response` provides some helpful accessor methods too.

```ruby
response.transaction_type
 => :cancel

response.http_code
 => "200"

response.json
 => {"replyCode"=>"0000", "replyMessage"=>"Response has been completed", "content"=>{"object"=>"tid testmid_123456.654321 was canceled before."}}
```

Apart from these it also responds to `message` and `body`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jagdeepsingh/paygate-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Paygate project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jagdeepsingh/paygate-ruby/blob/master/CODE_OF_CONDUCT.md).
