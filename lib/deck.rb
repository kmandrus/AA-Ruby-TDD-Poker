require_relative 'card.rb'

class Deck
    attr_reader :cards

    def initialize
        @cards = []
        Card.suits.each do |suit|
            Card.values.each do |value|
                @cards << Card.new(suit, value)
            end
        end
        @cards.shuffle!
    end

    def size
        @cards.size
    end

    def empty?
        @cards.empty?
    end

    def deal(num)
        if empty?
            raise "no cards in deck"
        elsif num > size
            raise "not enough cards left"
        else
            dealt_cards = []
            num.times { dealt_cards << @cards.pop }
            dealt_cards
        end
    end

    

end