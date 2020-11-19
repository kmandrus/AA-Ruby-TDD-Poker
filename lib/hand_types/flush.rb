require_relative "hand_type.rb"
require_relative "hand_type_mixins.rb"

class Flush < Hand_Type
    include High_Card_Comparison, Descending_Order

    def initialize(cards, ranking=6, name="flush")
        super
    end
end