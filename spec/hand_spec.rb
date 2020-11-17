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
    suit_converter = {
        "D" => :Diamonds,
        "H" => :Hearts,
        "S" => :Spades,
        "C" => :Clubs
    }
    card_set = cards_string.split.map do |str|
        suit = suit_converter[str[0]]
        value = str[1..-1].to_sym
        Card.new(suit, value)
    end
    Hand.new(card_set)
end
def test_between_hand_types
    context "when comparing hands of differing types, it" do
        ranked_hands = load_hands("spec/example_hands/test_hands_type.txt")
        ranked_hands.each_with_index do |hand, i|
            winning_hands = ranked_hands[0...i]
            winning_hands.each do |winning_hand|
                it "ranks a #{hand.type} lower than a #{winning_hand.type}" do
                    expect(hand <=> winning_hand).to eq(-1)
                end
            end
            losing_hands = ranked_hands[i+1..-1]
            losing_hands.each do |losing_hand|
                it "ranks a #{hand.type} higher than a #{losing_hand.type}" do
                    expect(hand <=> losing_hand).to eq(1)
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
def test_hands_of_type(type, hands)
    context "when comparing #{type}, it" do
        hands.each_with_index do |hand, i|
            winning_hands = hands[0...i]
            winning_hands.each do |winning_hand|
                it "ranks #{hand} lower than #{winning_hand}" do
                    expect(hand <=> winning_hand).to eq(-1)
                end
            end
            losing_hands = hands[i+1..-1]
            losing_hands.each do |losing_hand|
                it "ranks #{hand} higher than #{losing_hand}" do
                    expect(hand <=> losing_hand).to eq(1)
                end
            end
        end
    end
end
def test_within_hand_types
    hand_types = %w(straight_flushes four_of_a_kinds full_houses flushes straights three_of_a_kinds two_pairs pairs high_cards)
    hand_types.each do |type|
        example_hands = load_hands("spec/example_hands/" + type + ".txt")
        test_hands_of_type(type, example_hands)
    end
end

describe Hand do
    subject(:hand) do
        hand_strs = File.readlines("spec/example_hands/test_hands_type.txt")
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
            hand_strs = File.readlines("spec/example_hands/test_hands_type.txt")
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
        test_between_hand_types
        test_within_hand_types
        test_ties
    end
end