# CHANGELOG

## Next

## 0.2.2 - 2023-04-26

- [PR#12](https://github.com/tablecheck/paygate-ruby/pull/12) Re-add Rails Engine (was dropped in version 0.2.0) ([johnnyshields](https://github.com/johnnyshields))
- [PR#12](https://github.com/tablecheck/paygate-ruby/pull/12) Rename Paygate::ActionView::FormHelper to Paygate::Rails::FormHelper. ([johnnyshields](https://github.com/johnnyshields))

## 0.2.1 - 2023-04-26

- [PR#11](https://github.com/tablecheck/paygate-ruby/pull/11) Deep freeze constants. ([johnnyshields](https://github.com/johnnyshields))

## 0.2.0 - 2023-04-26

- [PR#9](https://github.com/tablecheck/paygate-ruby/pull/9) Rename Paygate::FormHelper to Paygate::ActionView::FormHelper. ([johnnyshields](https://github.com/johnnyshields))
- [PR#9](https://github.com/tablecheck/paygate-ruby/pull/9) Do not include Paygate::FormHelper in ActionView::Base. ([johnnyshields](https://github.com/johnnyshields))
- [PR#9](https://github.com/tablecheck/paygate-ruby/pull/9) Update BIN list. Note BINs can now be a flexible number of digits. ([johnnyshields](https://github.com/johnnyshields))
- [PR#9](https://github.com/tablecheck/paygate-ruby/pull/9) Rename data config YAML keys. ([johnnyshields](https://github.com/johnnyshields))
- [PR#10](https://github.com/tablecheck/paygate-ruby/pull/10) Add Rubocop and fix compliance issues. ([johnnyshields](https://github.com/johnnyshields))

## 0.1.11 - 2022-05-13

- [PR#7](https://github.com/tablecheck/paygate-ruby/pull/7) Fix missed files in gem package. ([johnnyshields](https://github.com/johnnyshields))
- [PR#6](https://github.com/jagdeepsingh/paygate-ruby/pull/6) Support Ruby 3.1. ([johnnyshields](https://github.com/johnnyshields))
- [PR#6](https://github.com/jagdeepsingh/paygate-ruby/pull/6) Change repo attribution to TableCheck. ([johnnyshields](https://github.com/johnnyshields))
- [PR#6](https://github.com/jagdeepsingh/paygate-ruby/pull/6) Add rudimentary CI test. ([johnnyshields](https://github.com/johnnyshields))

## 0.1.8 - 2020-02-11

- [PR#5](https://github.com/jagdeepsingh/paygate-ruby/pull/5) Add `verify` method to Transaction class and more meta fields to the payment form. ([jagdeepsingh](https://github.com/jagdeepsingh))

## 0.1.7 - 2019-11-01

- [PR#4](https://github.com/jagdeepsingh/paygate-ruby/pull/4) Update BIN numbers for Korean domestic cards (Oct 2019). ([jagdeepsingh](https://github.com/jagdeepsingh))

## 0.1.6 - 2019-02-01

- Update BIN numbers for Korean domestic cards (Feb 2019). ([jagdeepsingh](https://github.com/jagdeepsingh))

## 0.1.5 - 2019-01-21

- Update BIN numbers for Korean domestic cards (Jan 2019). ([jagdeepsingh](https://github.com/jagdeepsingh))

## 0.1.4 - 2018-04-20

- [PR#3](https://github.com/jagdeepsingh/paygate-ruby/pull/3) Make `Paygate` configurable with the help of a block. ([jagdeepsingh](https://github.com/jagdeepsingh))

## 0.1.2 - 2018-03-16

- Fix Bug - Pass correct value of _amount_ for full refund of a transaction. ([jagdeepsingh](https://github.com/jagdeepsingh))

## 0.1.1 - 2018-03-09

- [PR#1](https://github.com/jagdeepsingh/paygate-ruby/pull/1) Add raw info to the response of refund transaction. ([jagdeepsingh](https://github.com/jagdeepsingh))

## 0.1.0 - 2017-11-29

- Add view helper for rendering OpenPayAPI payment form with default values. ([jagdeepsingh](https://github.com/jagdeepsingh))
- Add Javascript helpers for accessing OpenPayAPI payment form and payment screen. ([jagdeepsingh](https://github.com/jagdeepsingh))
- Support full refund of a transaction using CancelAPI. ([jagdeepsingh](https://github.com/jagdeepsingh))
- Support future payments (Profile Pay) for existing customers. ([jagdeepsingh](https://github.com/jagdeepsingh))
