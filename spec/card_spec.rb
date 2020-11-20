require 'rspec'
require 'card'

describe Card do
    describe "#initialize" do
        let(:value) { :'10' }
        let(:suit) {:Spades}
        subject(:card) { described_class.new(suit, value) }

        it "should accept a suit and value" do
            expect{card}.to_not raise_error
        end
        it "should set a public suit instance variable" do
            expect(card.suit).to eq(suit)
        end
        it "should set a public value instance variable" do
            expect(card.value).to eq(value)
        end
        it "should raise an error if the value is invalid" do
            expect{described_class.new(suit, :'11')}.to raise_error "invalid value"
            expect{described_class.new(suit, :'1')}.to raise_error "invalid value"
            expect{described_class.new(suit, :'0')}.to raise_error "invalid value"
            expect{described_class.new(suit, :'-1')}.to raise_error "invalid value"
            expect{described_class.new(suit, :Ace)}.to raise_error "invalid value"
            expect{described_class.new(suit, :k)}.to raise_error "invalid value"
            expect{described_class.new(suit, "Ace")}.to raise_error "invalid value"
            expect{described_class.new(suit, "A")}.to raise_error "invalid value"
        end
        it "should raise an error if the suit is invalid" do
            expect{described_class.new(:spades, value)}.to raise_error "invalid suit"
            expect{described_class.new(:S, value)}.to raise_error "invalid suit"
            expect{described_class.new(:Shovels, value)}.to raise_error "invalid suit"
            expect{described_class.new("Spades", value)}.to raise_error "invalid suit"
        end
    end

    describe "::cards_from_string" do
        it "should accept a string as an arguement" do
            expect { described_class.cards_from_string("CA DJ") }
                .to_not raise_error
        end
        context "when passed an invalid string" do
            it "should raise an error" do
                expect { described_class.cards_from_string("UA") }
                    .to raise_error "invalid suit"
                expect { described_class.cards_from_string("C18") }
                    .to raise_error "invalid value"
            end
        end
        context "when passed a string of valid cards" do
            let(:card_string) { "DJ SA C3" }
            let(:cards) { [
                    Card.new(:Diamonds, :J), 
                    Card.new(:Spades, :A), 
                    Card.new(:Clubs, :'3')
                    ] }
            it "should convert the string into an array of cards" do
                expect(described_class.cards_from_string(card_string))
                    .to eq(cards)
            end
        end
        context "when passed an empty string" do
            let(:empty_string) { "" }
            let(:empty_array) { Array.new }
            it "should return an empty array" do
                expect(described_class.cards_from_string(empty_string))
                    .to eq(empty_array)
            end
        end
        
    end

    context "when comparing cards" do
        let(:ace) { :A }
        let(:ten) { :'10' }
        let(:nine) { :'9'}
        let(:jack) { :J }
        let(:jack_of_clubs) { described_class.new(:Clubs, jack) }
        let(:ten_of_hearts) { described_class.new(:Hearts, ten) }
        let(:ace_of_spades) { described_class.new(:Spades, ace) }
        let(:jack_of_diamonds) { described_class.new(:Diamonds, jack)}
        let(:nine_of_diamonds) { described_class.new(:Diamonds, nine) }
        let(:ace_of_hearts) { described_class.new(:Hearts, ace) }
        let(:ten_of_spades) { described_class.new(:Spades, ten) }

        describe "#<=>" do
            context "when the cards are equal face cards it" do
                subject(:jack_of_clubs) { described_class.new(:Clubs, jack) }
                it "should return 0" do
                    expect(jack_of_clubs <=> jack_of_diamonds).to eq(0)
                end
            end
            context "when the cards are equal number cards, it" do
                subject(:ten_of_spades) { described_class.new(:Spades, ten) }
                it "should return 0" do
                    expect(ten_of_spades <=> ten_of_hearts).to eq(0)
                    expect(ace_of_hearts <=> ace_of_spades).to eq(0)
                end
            end
            context "when the receiver is higher it" do
                it "should return 1" do
                    expect(ten_of_spades <=> nine_of_diamonds).to eq(1)
                    expect(jack_of_clubs <=> ten_of_spades).to eq(1)
                    expect(ace_of_hearts <=> jack_of_clubs).to eq(1)
                end
            end
            context "when the receiver is lower it" do
                it "should return -1" do
                    expect(nine_of_diamonds <=> ten_of_spades ).to eq(-1)
                    expect(ten_of_spades <=> jack_of_clubs).to eq(-1)
                    expect(jack_of_clubs <=> ace_of_hearts).to eq(-1)
                end
            end
        end
    end
end