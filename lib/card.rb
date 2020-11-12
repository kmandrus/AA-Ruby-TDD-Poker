require 'byebug'

class Card
    include Comparable
    attr_reader :suit, :value

    def self.suits
        SUIT_RANKINGS.keys
    end
    def self.values
        VALUE_RANKINGS.keys
    end

    def initialize(suit, value)
        raise "invalid suit" unless Card.suits.include?(suit)
        raise "invalid value" unless Card.values.include?(value)
        @suit = suit
        @value = value
    end

    def value_ranking
        VALUE_RANKINGS[value]
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

    private
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
        J: 11,
        Q: 12,
        K: 13,
        A: 14
    }.freeze
end