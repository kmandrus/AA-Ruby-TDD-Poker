require 'colorize'
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

    def to_s
        value.to_s + SUIT_TO_S[suit]
    end

    def <=>(card)
        VALUE_RANKINGS[value] <=> VALUE_RANKINGS[card.value]
    end

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
    SUIT_TO_S = {
        Clubs: '♣',
        Spades: '♠',
        Hearts: '♥'.colorize(:red),
        Diamonds: '♦'.colorize(:red)
    }.freeze
end