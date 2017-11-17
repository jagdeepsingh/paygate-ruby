module Paygate
  module FormHelper
    def paygate_open_pay_api_js_url
      'https://api.paygate.net/ajax/common/OpenPayAPI.js'.freeze
    end

    def paygate_open_pay_api_form(options = {})
      form_tag({}, name: 'PGIOForm') do
        fields = []

        fields << text_field_tag(:mid, options[:mid].try(:[], :value),
          placeholder: options[:mid].try(:[], :placeholder) || 'Member ID').html_safe

        fields << text_field_tag(:locale, options[:locale].try(:[], :value) || 'KR',
          name: 'langcode', placeholder: options[:locale].try(:[], :placeholder) || 'Language').html_safe

        fields << text_field_tag(:charset, options[:charset].try(:[], :value) || 'UTF-8',
          placeholder: options[:charset].try(:[], :placeholder) || 'Charset').html_safe

        fields << text_field_tag(:title, options[:title].try(:[], :value),
          name: 'goodname', placeholder: options[:title].try(:[], :placeholder) || 'Title').html_safe

        fields << text_field_tag(:currency, options[:currency].try(:[], :value) || 'WON',
          name: 'goodcurrency', placeholder: options[:currency].try(:[], :placeholder) || 'Currency').html_safe

        fields << text_field_tag(:amount, options[:amount].try(:[], :value),
          name: 'unitprice', placeholder: options[:amount].try(:[], :placeholder) || 'Amount').html_safe

        fields << text_field_tag(:pay_method, options[:pay_method].try(:[], :value) || 'card',
          name: 'paymethod', placeholder: options[:pay_method].try(:[], :placeholder) || 'Pay Method').html_safe

        fields << text_field_tag(:customer_name, options[:customer_name].try(:[], :value),
          name: 'receipttoname', placeholder: options[:customer_name].try(:[], :placeholder) || 'Customer Name').html_safe

        fields << text_field_tag(:customer_email, options[:customer_email].try(:[], :value),
          name: 'receipttoemail', placeholder: options[:customer_email].try(:[], :placeholder) || 'Customer Email').html_safe

        fields << text_field_tag(:card_number, options[:card_number].try(:[], :value),
          name: 'cardnumber', placeholder: options[:card_number].try(:[], :placeholder) || 'Card Number').html_safe

        fields << text_field_tag(:expiry_year, options[:expiry_year].try(:[], :value),
          name: 'cardexpireyear', placeholder: options[:expiry_year].try(:[], :placeholder) || 'Expiry Year').html_safe

        fields << text_field_tag(:expiry_month, options[:expiry_month].try(:[], :value),
          name: 'cardexpiremonth', placeholder: options[:expiry_month].try(:[], :placeholder) || 'Expiry Month').html_safe

        fields << text_field_tag(:cvv, options[:cvv].try(:[], :value),
          name: 'cardsecretnumber', placeholder: options[:cvv].try(:[], :placeholder) || 'CVV').html_safe

        fields << text_field_tag(:card_auth_code, nil,
          name: 'cardauthcode', placeholder: options[:card_auth_code].try(:[], :placeholder) || 'Card Auth Code').html_safe

        fields << text_field_tag(:response_code, nil,
          name: 'replycode', placeholder: options[:response_code].try(:[], :placeholder) || 'Response Code').html_safe

        fields << text_field_tag(:response_message, nil,
          name: 'replyMsg', placeholder: options[:response_message].try(:[], :placeholder) || 'Response Message').html_safe

        fields << text_field_tag(:tid, nil,
          placeholder: options[:tid].try(:[], :placeholder) || 'TID').html_safe

        fields << text_field_tag(:profile_no, nil,
          placeholder: options[:profile_no].try(:[], :placeholder) || 'Profile No').html_safe

        fields << text_field_tag(:hash_result, nil,
          name: 'hashresult', placeholder: options[:hash_result].try(:[], :placeholder) || 'Hash Result').html_safe

        fields.join.html_safe
      end.html_safe
    end

    def paygate_open_pay_api_screen
      content_tag(:div, nil, id: 'PGIOscreen')
    end
  end
end

ActionView::Base.send :include, Paygate::FormHelper
