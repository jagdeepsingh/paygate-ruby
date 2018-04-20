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

## Configuration

You can pass a block to the `configure` method to make changes to the `Paygate` configuration.

```ruby
Paygate.configure do |config|
  config.mode = :sandbox
end
```

Default value for `mode` is `:live`. It uses different API urls in different modes for making payments.

## Usage

To start making the transactions on PayGate, you will need a Member ID and a Secret, for which you can register [here](https://admin.paygate.net/front/regist/registMember.jsp?lang=us).

After a successful registration, you will have access to the [dashboard](https://admin.paygate.net/front/board/welcome.jsp).

NOTE: Unless otherwise stated, all the following documentation is for making payments with Korean local credit cards in currency 'WON'.

Contents:
- [1 Purchase](#1-purchase)
- [2 Refund](#2-refund)
- [3 Profile Pay](#3-profile-pay)

### 1 Purchase

#### 1.1 Include javascript

Include the _OpenPayAPI.js_ in `<head>` of your payment page.

```slim
= javascript_include_tag paygate_open_pay_api_js_url
```

#### 1.2 Payment form

Render the PayGate payment form in your view file.

```slim
= paygate_open_pay_api_form
```

You will see a form with all the necessary fields for making payment with a credit card. Some of the fields have default values set. You can also set the value and placeholder for almost all the fields while rendering the form. See example below:

```slim
/ payment.html.slim
= paygate_open_pay_api_form(\
    mid: { value: 'testmid', placeholder: 'Merchant ID' },
    currency: { value: 'USD' },
    amount: { value: 2000 }\
  )
```

Here is a list of all the form fields which you can set:
- mid
- locale (default: 'US')
- charset (default: 'UTF-8')
- title
- currency (default: 'WON')
- amount
- pay_method (default: 'card')
- customer_name
- customer_email
- card_number
- expiry_year
- expiry_month
- cvv

The form also contains some fields which will are filled after the response is returned by the API. They are:
- card_auth_code
- response_code
- response_message
- tid
- profile_no
- hash_result

Lets explore some of these fields more.

**mid**

You need to set your Member ID in this field.

If you have setup separate Member IDs for Korean and International cards, you can fill the value of `mid` accordingly. To know whether the credit card number entered by a customer is Korean or not, you can check the first 6 digits of card number to match Korean BIN numbers. Full list is available as `Paygate::KOREA_BIN_NUMBERS`.

**pay_method**

Value of `pay_method` for Korean cards should be set to "card" and for international cards, it should be "104".

**locale**

Use `Paygate.mapped_locale` to get the locale in correct format for the form input.

```ruby
Paygate.mapped_locale(:en)
 => 'US'

Paygate.mapped_locale('ko')
 => 'KR'
```

Valid inputs are "en", "en-US", "ko", "ko-KR", "ja", "zh-CN" and their symbolized versions. Passing `nil` would return default locale i.e. "US".

**currency**

Use `Paygate.mapped_currency` to get the currency in the correct format.

```ruby
Paygate.mapped_currency('USD')
 => 'USD'

Paygate.mapped_currency('KRW')
 => 'WON'
```

Passing `nil` above would return default currency i.e. "WON".

**amount**

You need to contact PayGate to know the correct amount for making a successful transaction in test mode.

Remember, in test mode too, PayGate makes real transactions and you need to `refund` them.

**tid**

For every transaction a `tid` is created by PayGate JS before making a request to the API.

**response_code**

This is filled automatically by PayGate JS when response is returned. A `response_code` of "0000" means successful transaction.

**response_message**

In case of failure, you can see the error message returned by the API here.

**profile_no**

If Profile Payment Service is enabled on your Member ID, then you will get a subscription ID for customer in this field. You can use this `profile_no` to make payments for the same customer in future.

#### 1.3 Response screen

You also need to add a screen at the same HTML level as above form. OpenPayAPI popups for further authentication as well as the response from the API is displayed in this screen.

```slim
= paygate_open_pay_api_screen
```

#### 1.4 Callbacks

You also need to implement a few callbacks to handle the API response. Add these to your Javascript.

```js
// This is called when a response is returned from PayGate API
function getPGIOresult() {
  displayStatus(getPGIOElement('ResultScreen'));
  verifyReceived(getPGIOElement('tid'), 'callbacksuccess', 'callbackfail');
}

// This is called when a response (success/failure) is returned from the API
function callbacksuccess() {
  var replycode = getPGIOElement('replycode');

  if (replycode == '0000') {
    alert('Payment was successful');
  } else {
    alert('Payment failed with code: ' + replycode);
  }
}

// This is called when there is a system error
function callbackfail() {
  alert('System error. Please try again.');
}
```

#### 1.5 Submit the form

Now finally, lets add an event to make a call to OpenPayAPI on submit of the form. If you are using jQuery, you can do it as follows:

```js
$('form[name="PGIOForm"]').on('submit', function(event){
  event.preventDefault();
  doTransaction(document.PGIOForm);
})
```

And, your payment form is all set to make payments.

### 2 Refund

Initialize a `Paygate::Member` instance using the Member ID and Secret you have.

```ruby
member = Paygate::Member.new('testmid', 'secret')
 => #<Paygate::Member:0x007f96bdb70f38 @mid="testmid", @secret="secret">
```

`member` responds to methods `mid`, and `secret`.

```ruby
member.mid
 => "testmid"

member.secret
 => "secret"
```

#### 2.1 Full refund

```ruby
response = member.refund_transaction('testmid_123456.654321')
 => #<Paygate::Response:0x007fbf3d111940 @transaction_type=:refund, @http_code="200", @message="OK", @body="callback({\"replyCode\":\"0000\",\"replyMessage\":\"Response has been completed\",\"content\":{\"object\":\"CancelAPI tid:testmid_123456.654321 SUCCESS payRsltCode:0000\"}})", @json={"replyCode"=>"0000", "replyMessage"=>"Response has been completed", "content"=>{"object"=>"CancelAPI tid:testmid_123456.654321 SUCCESS payRsltCode:0000"}}, @raw_info=
  #<OpenStruct tid="testmid_123456.654321", tid_enc="AES256XQIdNnkzFwMQmhF7fuJhS3m0\n", request_url="https://service.paygate.net/service/cancelAPI.json?callback=callback&mid=testmid&tid=AES256XQIdNnkzFwMQmhF7fuJhS3m0%0A&amount=F">>
```

Here, _testmid_123456.654321_ is `tid` of the transaction you want to refund.

`response` provides some helpful accessor methods too.

```ruby
response.transaction_type
 => :refund

response.http_code
 => "200"

response.json
 => {"replyCode"=>"0000", "replyMessage"=>"Response has been completed", "content"=>{"object"=>"CancelAPI tid:testmid_123456.654321 SUCCESS payRsltCode:0000"}}

response.raw_info
 => #<OpenStruct tid="testmid_123456.654321", tid_enc="AES256XQIdNnkzFwMQmhF7fuJhS3m0\n", request_url="https://service.paygate.net/service/cancelAPI.json?callback=callback&mid=testmid&tid=AES256XQIdNnkzFwMQmhF7fuJhS3m0%0A&amount=F">

response.raw_info.request_url
 => "https://service.paygate.net/service/cancelAPI.json?callback=callback&mid=testmid&tid=AES256XQIdNnkzFwMQmhF7fuJhS3m0%0A&amount=F"
```

Apart from these it also responds to `message` and `body`.

#### 2.2 Partial refund

For partial refunds, you need to pass `amount` as an option to `refund_transaction` method along with other options.

```ruby
response = member.refund_transaction('testmid_123456.654321',
                                     amount: 1000,
                                     order_id: 'ord10001')
```

### 3 Profile Pay

You can use the `profile_no` returned from the OpenPayAPI after first payment by a customer to make future payments for him.

```ruby
response = member.profile_pay('profile_1234567890', 'WON', 1000)

response.transaction_type
 => :profile_pay

response.http_code
 => "200"

response.json
 => {"validecode"=>"00", "authcode"=>"12345678", "authdt"=>"20171120165728", "cardname"=>"BC \x00\x00\x00\x00", "cardnumber"=>"411111**********", "cardtype"=>"301310", "cardquota"=>"00", "cardexpiremonth"=>"11", "cardexpireyear"=>"2020", "merchantno"=>"12345678", "m_tid"=>nil, "paymethodname"=>"CARD_BASIC", "ReplyMsg"=>"\xBA\xBA\xBC\xBD\xC1\xC2\xC3\xC4        OK: 12345678", "ReplyCode"=>"0000", "receipttoname"=>"Test name\xC1\xD1\xB1\xB1\xC1\xA1", "receipttoemail"=>"dev@paygate.net", "subtotalprice"=>"1000", "transactionid"=>"testmid_123456.654321", "hashresult"=>"db1fdc6789cc8d088172b79ca680b3af8711e9fb32", "mb_serial_no"=>"\r\n"}
```

### 4 Javascript helpers

`paygate-ruby` also provides a Javascript class `Paygate` with some helper functions that can be used in your Javascript e.g.

- _openPayApiForm_ - Returns the payment form
- _openPayApiScreen_ - Returns the screen for paygate API response
- _findInputByName_ - Find an input field in payment form by name. Pass the _camelCased_ form of field names from section 1.2 above as arguments.
- _responseCode_
- _responseMessage_
- _tid_
- _profileNo_
- _fillInput_ - Accepts input name (_camelCased_) and a value to set
- _submitForm_ - Makes a call to PayGate API with the payment form inputs

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jagdeepsingh/paygate-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Paygate project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jagdeepsingh/paygate-ruby/blob/master/CODE_OF_CONDUCT.md).
