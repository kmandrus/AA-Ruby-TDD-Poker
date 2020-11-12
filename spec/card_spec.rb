require 'rspec'
require 'card'

describe Card do
    describe "#initialize" do
        let(:value) { :'10' }
        subject(:card) { Card.new(:Spades, value) }
        it "should accept a suit and value" do
            expect{card}.to_not raise_error
        end
        it "should set a public suit instance variable" do
            expect(card.suit).to eq(:Spades)
        end
        it "should set a public value instance variable" do
            expect(card.value).to eq(value)
        end
        it "should raise an error if the value is invalid" do
            expect{Card.new(:Spades, :'11')}.to raise_error "invalid value"
            expect{Card.new(:Spades, :'1')}.to raise_error "invalid value"
            expect{Card.new(:Spades, :'0')}.to raise_error "invalid value"
            expect{Card.new(:Spades, :'-1')}.to raise_error "invalid value"
            expect{Card.new(:Spades, :Ace)}.to raise_error "invalid value"
            expect{Card.new(:Spades, :k)}.to raise_error "invalid value"
            expect{Card.new(:Spades, "Ace")}.to raise_error "invalid value"
            expect{Card.new(:Spades, "A")}.to raise_error "invalid value"
        end
        it "should raise an error if the suit is invalid" do
            expect{Card.new(:spades, :'10')}.to raise_error "invalid suit"
            expect{Card.new(:S, :'10')}.to raise_error "invalid suit"
            expect{Card.new(:Shovels, :'10')}.to raise_error "invalid suit"
            expect{Card.new("Spades", :'10')}.to raise_error "invalid suit"
        end
    end

    context "when comparing cards" do
        let(:ace) { :A }
        let(:ten) { :'10' }
        let(:nine) { :'9'}
        let(:jack) { :J }
        subject(:ten_of_spades) { Card.new(:Spades, ten) }
        let(:ace_of_spades) { Card.new(:Spades, ace) }
        let(:ten_of_hearts) { Card.new(:Hearts, ten) }
        let(:nine_of_diamonds) { Card.new(:Diamonds, nine) }
        let(:ace_of_hearts) { Card.new(:Hearts, ace) }
        let(:jack_of_clubs) { Card.new(:Clubs, jack) }
        let(:other_ten_of_hearts) { Card.new(:Hearts, ten) }
        let(:other_jack_of_clubs) { Card.new(:Clubs, jack) }

        describe "#<=>" do
            context "when the cards are equal" do
                it "should return 0" do
                    expect(ten_of_hearts <=> other_ten_of_hearts).to eq(0)
                    expect(jack_of_clubs <=> other_jack_of_clubs).to eq(0)
                end
            end
            context "when the receiver is higher" do
                it "should return 1" do
                    expect(ten_of_spades <=> nine_of_diamonds).to eq(1)
                    expect(jack_of_clubs <=> ten_of_spades).to eq(1)
                    expect(ace_of_hearts <=> jack_of_clubs).to eq(1)
                    expect(ace_of_hearts <=> ace_of_spades).to eq(1)
                    expect(ten_of_hearts <=> ten_of_spades).to eq(1)
                end
                
            end
            context "when the receiver is lower" do
                it "should return -1" do
                    expect(nine_of_diamonds <=> ten_of_spades ).to eq(-1)
                    expect(ten_of_spades <=> jack_of_clubs).to eq(-1)
                    expect(jack_of_clubs <=> ace_of_hearts).to eq(-1)
                    expect(ace_of_spades <=> ace_of_hearts).to eq(-1)
                    expect(ten_of_spades <=> ten_of_hearts).to eq(-1)
                end
            end
        end
    end
end