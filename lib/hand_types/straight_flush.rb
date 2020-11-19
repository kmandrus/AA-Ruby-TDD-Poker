require_relative "hand_type.rb"
require_relative "hand_type_mixins.rb"

class Straight_Flush < Hand_Type
    include Straight_Comparison, Descending_Order

    def initialize(cards, ranking=9, name="straight flush")
        super
    end

end