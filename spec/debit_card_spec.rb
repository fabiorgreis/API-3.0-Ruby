require "cielo/api30"

describe Cielo::API30::Sale do
    subject { described_class.new("1") }

    describe "#generate_debit_card" do
        before do
            subject.customer = Cielo::API30::Customer.new("Fulano de Tal")
            subject.payment = Cielo::API30::Payment.new(100)
            subject.payment.type = Cielo::API30::Payment::PAYMENTTYPE_DEBITCARD
            subject.payment.return_url = "http://localhost:3000/"
            subject.payment.debit_card = Cielo::API30::DebitCard.new(security_code: "123", brand: "Visa")
            subject.payment.debit_card.expiration_date = "01/2018"
            subject.payment.debit_card.holder = "Fulano de Tal"
            subject.payment.debit_card.card_number = "0000000000000007"                        
        end

        it "should generate right json" do
            jsn = {"MerchantOrderId":"1",
                   "Customer":
                   {
                       "Name":"Fulano de Tal"
                   },
                   "Payment":
                   {
                       "Installments":1,
                       "DebitCard":
                       {
                           "CardNumber":"0000000000000007",
                           "Holder":"Fulano de Tal",
                           "ExpirationDate":"01/2018",
                           "SecurityCode":"123",
                           "Brand":"Visa"
                        },
                        "ReturnUrl":"http://localhost:3000/",
                        "Type":"DebitCard",
                        "Amount":100
                    }
                }
            expect(subject.to_json).to match(jsn.to_json)
        end

        it "send sale request" do            
            merchant = Cielo::API30.merchant("", "")
            cielo_api = Cielo::API30.client(merchant, Cielo::API30::Environment::sandbox)
            sale = cielo_api.create_sale(subject)  
            puts sale.payment.return_info.message
            puts sale.payment.return_info.code
            puts sale.payment.return_code
            puts sale.payment.return_message
            puts sale.payment.payment_id
            puts sale.payment.proof_of_sale
            puts sale.payment.tid
            puts sale.payment.authorization_code
            puts sale.payment.status
            puts sale.to_json
            expect(sale.payment.payment_id).not_to be_empty
        end
    end
end
