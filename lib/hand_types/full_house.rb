require_relative "hand_type.rb"
require_relative "hand_type_mixins.rb"

class Full_House < Hand_Type
    attr_reader :triple, :pair
    include Group_by_Value

    def initialize(cards, ranking=7, name="full house")
        super
        @triple = group_by_value.select { |group| group.size == 3 }
        @pair = group_by_value.select { |group| group.size == 2 }
    end

    private
    def compare_hands_of_same_rank(other)
        triple_result = triple.first <=> other.triple.first
        unless triple_result == 0
            triple_result
        else
            pair.first <=> other.pair.first
        end
    end
    
end