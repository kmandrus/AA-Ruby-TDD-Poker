require 'byebug'

class Card
    attr_reader :suit, :value
    SUIT_RANKINGS = {
        Clubs: 1,
        Spades: 2,
        Hearts: 3,
        Diamonds: 4
    }.freeze
    VALUE_RANKINGS = {
        '2': 2,
        '3': 3,
        '4': 4,
        '5': 5,
        '6': 6,
        '7': 7,
        '8': 8,
        '9': 9,
        '10': 10,
        Jack: 11,
        Queen: 12,
        King: 13,
        Ace: 14
    }.freeze

    def self.suit_of_cards(suit)
        raise "invalid suit" unless SUIT_RANKINGS.keys.include?(suit)
        VALUE_RANKINGS.keys.map { |value| Card.new(suit, value) }
    end
    
    def self.fifty_two_cards
        cards = []
        SUIT_RANKINGS.keys.each do |suit|
            cards += self.suit_of_cards(suit)
        end
        cards
    end

    def initialize(suit, value) 
        @suit = suit
        @value = value
    end

    def >(card)
        self_val, other_val = VALUE_RANKINGS[value], VALUE_RANKINGS[card.value]
        unless self_val == other_val
            return self_val > other_val
        else
            return SUIT_RANKINGS[suit] > SUIT_RANKINGS[card.suit]
        end
    end

    def <(card)
        self_val, other_val = VALUE_RANKINGS[value], VALUE_RANKINGS[card.value]
        unless self_val == other_val
            return self_val < other_val
        else
            return SUIT_RANKINGS[suit] < SUIT_RANKINGS[card.suit]
        end
    end

    def ==(card)
        self.value == card.value && self.suit == card.suit
    end
end