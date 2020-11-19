class Hand_Type
    include Comparable
    attr_reader :ranking, :name

    def initialize(cards, ranking, name)
        @cards = cards
        @ranking = ranking
        @name = name
    end

    def <=> (other)
        if ranking == other.ranking
            compare_hands_of_same_rank(other)
        else
            compare_hands_of_different_rank(other)
        end
    end

    def cards
        @cards.dup
    end

    private
    def compare_hands_of_same_rank(other)
        raise "subclass must override"
    end
    def compare_hands_of_different_rank(other)
        ranking <=> other.ranking
    end
end