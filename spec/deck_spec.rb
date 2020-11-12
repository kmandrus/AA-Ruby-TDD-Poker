require 'rspec'
require 'deck'

describe Deck do
    let(:values) { %i(2 3 4 5 6 7 8 9 10 J Q K A) }
    let(:suits) { %i(Clubs Spades Hearts Diamonds) }
    let(:mock_card_class) do
        mock_card_class = double("Card")
        allow(mock_card_class).to receive(:suits) { suits }
        allow(mock_card_class).to receive(:values) { values }
        suits.each do |suit|
            values.each do |value|
                allow(mock_card_class)
                    .to receive(:new)
                    .with(suit, value) 
                    .and_return(double("card", :suit => suit, :value => value)) 
            end
        end
        mock_card_class
    end
    subject(:deck) do
        stub_const("Card", mock_card_class )
        Deck.new
    end

    describe "#initialize" do
        
        it 'should set a public cards array' do
            expect {deck.cards}.to_not raise_error
        end
        it "should create a standard deck of 52 cards" do
            expect(deck.cards.size).to eq(52)

        end
        it "should be shuffled" do
            decks = [deck, Deck.new]
            decks.map! do |deck|
                deck.cards.map {|card| [card.suit, card.value]}
            end 
            expect(decks.first).to_not eq(decks.last)
        end
        
    end

    describe '#size' do
        it "should return the number of cards left in the deck" do
            expect(deck.size).to eq(deck.cards.size)
        end
    end

    describe '#deal' do
        it "accepts a number of cards parameter" do
            expect {deck.deal(2)}.to_not raise_error
        end
        it "should reduce the size of the deck by the number of cards dealt" do
            current_size = deck.size
            deck.deal(1)
            expect(deck.size).to eq(current_size - 1)
            current_size = deck.size
            deck.deal(3)
            expect(deck.size).to eq(current_size - 3)
        end
        it "should raise an error if the deck is empty" do
            deck.deal(deck.size)
            expect {deck.deal(1)}.to raise_error "no cards in deck"
        end
        it "raises an error if not enough cards are left" do
            expect { deck.deal(deck.size + 1) }
                .to raise_error "not enough cards left"
        end
    end

    describe "#empty?" do
        it "should return false if the deck has cards remaining" do
            expect(deck.empty?).to be false

        end
        context "when the deck is empty" do
            it "should return true" do
                deck.deal(deck.size)
                expect(deck.empty?).to be true
            end
        end
    end
    
end