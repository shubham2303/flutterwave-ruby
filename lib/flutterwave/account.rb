require 'flutterwave/utils/helpers'
require 'flutterwave/utils/missing_key_error'
require 'flutterwave/response'

module Flutterwave
  class Account
    include Flutterwave::Helpers
    attr_accessor :client, :options

    def initialize(client)
      @client = client
    end

    def charge(options)
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        validateoption: encrypt(:validateoption),
        accountnumber: encrypt(:accountnumber),
        bankcode: encrypt(:bankcode),
        amount: encrypt(:amount),
        currency: encrypt(:currency),
        firstname: encrypt(:firstname),
        lastname: encrypt(:lastname),
        email: encrypt(:email),
        narration: encrypt(:narration),
        transactionreference: encrypt(:transactionreference),
        merchantid: client.merchant_key
      }

      request_params = request_params.merge(
        passcode: encrypt(:passcode)
      ) if options[:passcode]

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:charge_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def resend(options)
      @options = options

      request_params = {
        validateoption: encrypt(:validateoption),
        transactionreference: encrypt(:transactionreference),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:resend_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def validate(options)
      @options = options

      request_params = {
        otp: encrypt(:otp),
        transactionreference: encrypt(:transactionreference),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:validate_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def alt_validate(options)
      @options = options

      request_params = {
        otp: encrypt(:otp),
        phonenumber: encrypt(:phonenumber),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:alt_validate_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def encrypt(key)
      plain_text = options[key].to_s
      raise Flutterwave::Utils::MissingKeyError.new(
        "#{key.capitalize} key required!"
      ) if plain_text.empty?

      encrypt_data(plain_text, client.api_key)
    end
  end
end
