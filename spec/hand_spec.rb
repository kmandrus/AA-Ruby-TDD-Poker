require 'rspec'
require 'hand'
require 'card'

def load_hands(file_path)
    hands = []
    File.open(file_path, 'r').each do |hand_str|
        hands << to_hand(hand_str)
    end
    hands
end
def to_hand(cards_string)
    cards = Card.cards_from_string(cards_string)
    Hand.new(cards)
end
def test_hands_ordered_best_to_worst(file_name)
    hands = load_hands("spec/example_hands/" + file_name + ".txt")
    hands.each_with_index do |hand, test_i|
        hands.each_with_index do |other_hand, other_i|
            context "when comparing #{file_name}" do
                subject(:test_hand) { hand }
                if test_i < other_i
                    let(:winning_hand) { other_hand }
                    it "#{hand} beats #{other_hand}" do
                        expect(test_hand <=> winning_hand).to eq(1)
                    end
                elsif test_i > other_i
                    let(:winning_hand) { other_hand }
                    it "#{hand} loses to #{other_hand}" do
                        expect(test_hand <=> winning_hand).to eq(-1)
                    end
                end
            end
        end
    end
end
def test_ties
    hands = load_hands("spec/example_hands/ties.txt")
    context "when the hands are tied, it"
    i = 0
    while i < hands.length do
        it "returns 0" do
            hand_1, hand_2 = hands[i], hands[i+1]
            expect(hand_1 <=> hand_2).to eq(0)
        end
        i += 2
    end
end

describe Hand do
    subject(:hand) do
        hand_strs = File.readlines("spec/example_hands/hands_of_different_types.txt")
        to_hand(hand_strs[3]) 
    end

    describe "#initialize" do
        context "when not passed cards" do
            subject(:hand) { Hand.new }
            it "creates an empty public cards array" do
                expect { hand.cards }.to_not raise_error
                expect(hand.cards).to be_an Array
                expect(hand.cards).to be_empty
            end
        end
        context "when passed cards" do
            let(:cards) { Array.new(5, double("card")) }
            subject(:hand) { Hand.new(cards) }
            it "sets the cards variable to the passed cards" do
                expect(hand.cards).to eq(cards)
            end
        end
    end
    describe "#grouped_cards" do
        subject(:hand) do
            hand_strs = File.readlines("spec/example_hands/hands_of_different_types.txt")
            to_hand(hand_strs[1]) 
        end
        let(:groups) do
            [ 
                [
                    Card.new(:Diamonds, :J),
                    Card.new(:Hearts, :J),
                    Card.new(:Spades, :J),
                    Card.new(:Clubs, :J)
                ],
                [Card.new(:Hearts, :'7')]
            ]
        end
        it "creates an array of arrays with cards grouped by value" do
            expect(hand.grouped_cards).to eq(groups)
        end   
    end

    describe "#discard" do
        let(:two_of_hearts) { Card.new(:Hearts, :'2') }
        let(:king_of_hearts) { Card.new(:Hearts, :'K')}
        let(:discards) { [two_of_hearts, king_of_hearts] }
        let(:ace_of_spades) { Card.new(:Spades, :A) }
        it "accepts an array of cards as an arguement" do
            expect{ hand.discard(discards) }.to_not raise_error
        end
        it "deletes the passed cards from the hand" do 
            hand.discard(discards)
            expect(hand.cards).to_not include(two_of_hearts)
            expect(hand.cards).to_not include(king_of_hearts)
        end
        it "raises an error if it cannot delete any of the cards" do
            expect{ hand.discard([ace_of_spades]) }.to raise_error "card to discard not in hand"
        end
    end

    describe "#add" do
        let(:ace_of_spades) { Card.new(:Spades, :A) }
        let(:jack_of_spades) { Card.new(:Spades, :J) }
        let(:new_cards) { [ace_of_spades, jack_of_spades] }
        it "accepts an array of new cards as an argument" do
            expect{ hand.add(new_cards)}.to_not raise_error
        end
        it "adds the new cards to the hand" do
            hand.add(new_cards)
            expect(hand.cards).to include(ace_of_spades)
            expect(hand.cards).to include(jack_of_spades)
        end
    end

    describe "#<=>" do
        filenames_of_hands = %w(
            hands_of_different_types
            straight_flushes 
            four_of_a_kinds 
            full_houses 
            flushes 
            straights 
            three_of_a_kinds 
            two_pairs 
            pairs 
            high_cards)
            filenames_of_hands.each do |filename|
                test_hands_ordered_best_to_worst(filename)
            end
        test_ties
    end
end