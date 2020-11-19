require_relative "hand_type.rb"
require_relative "hand_type_mixins.rb"


class High_Card < Hand_Type
    include High_Card_Comparison, Descending_Order, Group_by_Value

    def initialize(cards, ranking=1, name="high card")
        super
    end
    
end