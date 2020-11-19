require_relative "hand_type.rb"
require_relative "hand_type_mixins.rb"

class Straight < Hand_Type
    include Descending_Order, Straight_Comparison
    
    def initialize(cards, ranking=5, name="straight")
        super
    end
    
end