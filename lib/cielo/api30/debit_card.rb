module Cielo
  module API30
    # Debit card data
    #
    # @attr [String] card_number Debit card number
    # @attr [String] holder Holder name
    # @attr [String] expiration_date Debit card expiration date
    # @attr [String] security_code Debit card security code
    # @attr [Boolean] save_card Whether or not to save the card
    # @attr [String] brand Debit card brand
    # @attr [String] card_token Card token
    class DebitCard
      attr_accessor :card_number,
                    :holder,
                    :expiration_date,
                    :security_code,
                    :save_card,
                    :brand,
                    :card_token

      def initialize(args = {})
        @security_code = args[:security_code]
        @brand = args[:brand]
        @card_token = args[:token]
      end

      def to_json(*options)
        hash = as_json(*options)
        hash.reject! {|k,v| v.nil?}
        hash.to_json(*options)
      end

      def self.from_json(data)
        return if data.nil?

        debit_card = new
        debit_card.card_number = data["CardNumber"]
        debit_card.holder = data["Holder"]
        debit_card.expiration_date = data["ExpirationDate"]
        debit_card.security_code = data["SecurityCode"]
        debit_card.save_card = data["SaveCard"]
        debit_card.brand = data["Brand"]
        debit_card.card_token = data["CardToken"]
        debit_card
      end

      def as_json(options={})
        {
          CardNumber: @card_number,
          Holder: @holder,
          ExpirationDate: @expiration_date,
          SecurityCode: @security_code,
          SaveCard: @save_card,
          Brand: @brand,
          CardToken: @card_token
        }
      end
    end
  end
end
