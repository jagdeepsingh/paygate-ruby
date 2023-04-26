# frozen_string_literal: true

module Paygate
  module ActionView
    module FormHelper
      PAYGATE_FORM_TEXT_FIELDS = {
        mid: {
          placeholder: 'Member ID'
        },

        locale: {
          name: 'langcode',
          default: 'KR',
          placeholder: 'Language'
        },

        charset: {
          default: 'UTF-8',
          placeholder: 'Charset'
        },

        title: {
          name: 'goodname',
          placeholder: 'Title'
        },

        currency: {
          name: 'goodcurrency',
          default: 'WON',
          placeholder: 'Currency'
        },

        amount: {
          name: 'unitprice',
          placeholder: 'Amount'
        },

        meta1: {
          name: 'goodoption1',
          placeholder: 'Good Option 1'
        },

        meta2: {
          name: 'goodoption2',
          placeholder: 'Good Option 2'
        },

        meta3: {
          name: 'goodoption3',
          placeholder: 'Good Option 3'
        },

        meta4: {
          name: 'goodoption4',
          placeholder: 'Good Option 4'
        },

        meta5: {
          name: 'goodoption5',
          placeholder: 'Good Option 5'
        },

        pay_method: {
          name: 'paymethod',
          default: 'card',
          placeholder: 'Pay Method'
        },

        customer_name: {
          name: 'receipttoname',
          placeholder: 'Customer Name'
        },

        customer_email: {
          name: 'receipttoemail',
          placeholder: 'Customer Email'
        },

        card_number: {
          name: 'cardnumber',
          placeholder: 'Card Number'
        },

        expiry_year: {
          name: 'cardexpireyear',
          placeholder: 'Expiry Year'
        },

        expiry_month: {
          name: 'cardexpiremonth',
          placeholder: 'Expiry Month'
        },

        cvv: {
          name: 'cardsecretnumber',
          placeholder: 'CVV'
        },

        card_auth_code: {
          name: 'cardauthcode',
          placeholder: 'Card Auth Code'
        },

        response_code: {
          name: 'replycode',
          placeholder: 'Response Code'
        },

        response_message: {
          name: 'replyMsg',
          placeholder: 'Response Message'
        },

        tid: {
          placeholder: 'TID'
        },

        profile_no: {
          placeholder: 'Profile No'
        },

        hash_result: {
          name: 'hashresult',
          placeholder: 'Hash Result'
        }
      }.freeze

      def paygate_open_pay_api_js_url
        if Paygate.configuration.mode == :live
          'https://api.paygate.net/ajax/common/OpenPayAPI.js'
        else
          'https://stgapi.paygate.net/ajax/common/OpenPayAPI.js'
        end
      end

      def paygate_open_pay_api_form(options = {})
        form_tag({}, name: 'PGIOForm') do
          fields = []

          PAYGATE_FORM_TEXT_FIELDS.each do |key, opts|
            arg_opts = options[key] || {}
            fields << text_field_tag(
              key,
              arg_opts[:value] || opts[:default],
              name: opts[:name] || key.to_s,
              placeholder: arg_opts[:placeholder] || opts[:placeholder]
            ).html_safe
          end

          fields.join.html_safe
        end.html_safe
      end

      def paygate_open_pay_api_screen
        content_tag(:div, nil, id: 'PGIOscreen')
      end
    end
  end
end
