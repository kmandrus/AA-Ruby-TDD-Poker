require_relative 'card.rb'

class Deck
    attr_reader :cards

    def initialize
        @cards = Card.fifty_two_cards
        @cards.shuffle!
    end

    def size
        @cards.size
    end

    def empty?
        @cards.empty?
    end

    def draw
        unless empty?
            @cards.pop
        else
            raise "no cards in deck"
        end
    end

    

end