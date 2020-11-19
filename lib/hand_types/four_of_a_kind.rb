require_relative "hand_type.rb"
require_relative "hand_type_mixins.rb"
require 'byebug'

class Four_of_a_Kind < Hand_Type
    include Group_by_Value, Num_of_a_Kind_Comparison

    def initialize(cards, ranking=8, name='four of a kind')
        super
    end
end