require 'byebug'

class Card
    include Comparable
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
    
    def self.standard_52_cards
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

    def <=>(card)
        self_value = VALUE_RANKINGS[value]
        other_value = VALUE_RANKINGS[card.value]
        if self_value == other_value
            self_suit_rank = SUIT_RANKINGS[suit] 
            other_suit_rank = SUIT_RANKINGS[card.suit]
            if self_suit_rank == other_suit_rank
                return 0
            elsif self_suit_rank > other_suit_rank
                return 1
            else
                return -1
            end
        elsif self_value > other_value
            return 1
        else
            return -1
        end
    end
end