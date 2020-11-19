require_relative "hand_type.rb"
require_relative "hand_type_mixins.rb"

class Pair < Hand_Type
    include Group_by_Value, Num_of_a_Kind_Comparison

    def initialize(cards, ranking=2, name='pair')
        super
    end
    
end