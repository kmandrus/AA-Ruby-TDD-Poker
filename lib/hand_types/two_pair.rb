require_relative "hand_type.rb"
require_relative 'hand_type_mixins.rb'

class Two_Pair < Hand_Type
    attr_reader :high_pair, :low_pair, :kicker
    include Group_by_Value
    
    def initialize(cards, ranking=3, name="two pair")
        super
        pairs = group_by_value.select { |group| group.size == 2 }
        @high_pair, @low_pair = pairs
        unless @high_pair.first > @low_pair.first 
            @low_pair, @high_pair = @high_pair, @low_pair
        end
        @kicker = group_by_value.select { |group| group.size == 1 }.flatten.first
    end

    private
    def compare_hands_of_same_rank(other)
        high_pair_result = high_pair.first <=> other.high_pair.first
        low_pair_result = low_pair.first <=> other.low_pair.first
        if high_pair_result != 0
            high_pair_result
        elsif low_pair_result != 0
            low_pair_result
        else
            kicker <=> other.kicker
        end
    end
end