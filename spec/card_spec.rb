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
    end

    context "when comparing cards" do
        let(:ace) { :Ace }
        let(:ten) { :'10' }
        let(:nine) { :'9'}
        let(:jack) { :Jack }
        subject(:ten_of_spades) { Card.new(:Spades, ten) }
        let(:ace_of_spades) { Card.new(:Spades, ace) }
        let(:ten_of_hearts) { Card.new(:Hearts, ten) }
        let(:nine_of_diamonds) { Card.new(:Diamonds, nine) }
        let(:ace_of_hearts) { Card.new(:Hearts, ace) }
        let(:jack_of_clubs) { Card.new(:Clubs, jack) }
        let(:other_ten_of_hearts) { Card.new(:Hearts, ten) } 

        describe "#<=>" do
            context "when the cards are equal" do
                it "should return 0" do
                    expect(ten_of_hearts <=> other_ten_of_hearts).to eq(0)
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
    
    context "when creating sets of cards" do
        let(:suits) { [:Clubs, :Spades, :Hearts, :Diamonds] }
        let(:values) { [
            :'2',
            :'3',
            :'4',
            :'5',
            :'6',
            :'7',
            :'8',
            :'9',
            :'10',
            :Jack,
            :Queen,
            :King,
            :Ace] }
        subject(:suits_of_cards) do 
            suits.map do |suit|
                Card.suit_of_cards(suit)
            end
        end

        describe "::suit_of_cards" do
            it "should accept a suit parameter" do
                expect { Card.suit_of_cards(:Hearts) }.to_not raise_error
            end
            it "should accept the four standard suits" do
                expect do 
                    suits.each { |suit| Card.suit_of_cards(suit) } 
                end.to_not raise_error
            end
            it "should raise an error if the suit isn't valid" do
                expect { Card.suit_of_cards(:Shovels) }.to raise_error "invalid suit"
            end
            it "should return an array of 13 cards" do
                expect( 
                    suits_of_cards.all? { |set| set.length == 13 }
                ).to be true
            end
            it "should contain each card in the suit exactly once" do
                expect(
                    suits_of_cards.all? do |set|
                        set.all? do |card|
                            card.suit == set.first.suit
                        end
                    end
                ).to be true
                expect(
                    suits_of_cards.map { |set| set.first.suit } == suits
                ).to be true
                expect( 
                    suits_of_cards.all? do |set|
                        set.map { |card| card.value } == values
                    end
                ).to be true
            end
        end

        describe "::standard_52_cards" do
            subject(:cards) { Card.standard_52_cards }
            let(:reference_deck) do 
                reference_deck = []
                suits.each { |suit| reference_deck += Card.suit_of_cards(suit) }
                reference_deck 
            end
            it "should return an array that holds a standard set of 52 cards" do
                expect(cards.length).to eq(52)
                cards.each do |card| 
                    reference_deck.delete(card) if reference_deck.include?(card)
                end
                expect( reference_deck.length ).to eq(0)
            end
        end
    end
    
end