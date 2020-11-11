require 'rspec'
require 'deck'

describe Deck do
    let(:cards) { [3, 2, 1] }
    let(:mock_card_class) do
        mock_card_class = double("Card")
        allow(mock_card_class).to receive(:fifty_two_cards).and_return(cards)
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
        it "should be shuffled" do
            expect(cards).to receive(:shuffle!)
            deck
        end
        it "should call Cards::fifty_two_cards" do
            expect(mock_card_class).to receive(:fifty_two_cards)
            deck
        end
    end

    describe '#size' do
        it "should return the number of cards left in the deck" do
            expect(deck.size).to eq(3)
        end
    end

    describe "#empty?" do
        it "should return false if the deck has cards remaining" do
            expect(deck.empty?).to be false

        end
        context "when the deck is empty" do
            let(:cards) { [] }
            it "should return true" do
                expect(deck.empty?).to be true
            end
        end
    end

    describe '#draw' do
        it "should return the top card of the deck" do
            expect(deck.cards.last).to eq(deck.draw)
        end
        it "should reduce the size of the deck by 1" do
            current_size = deck.size
            deck.draw
            expect(deck.size).to eq(current_size - 1)
        end
        it "should raise an error if the deck is empty" do
            deck.size.times {deck.draw}
            expect {deck.draw}.to raise_error "no cards in deck"
        end
    end
    
end