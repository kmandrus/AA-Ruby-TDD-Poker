module Straight_Comparison
    def compare_hands_of_same_rank(other)
        leading_card <=> other.leading_card
    end
    def straight_order
        ordered_cards = descending_order
        if ordered_cards[0].value == :A && ordered_cards[1].value != :K
            ordered_cards << ordered_cards.shift
        end
        ordered_cards
    end
    def leading_card
        straight_order.first
    end
end

module Group_by_Value
    def group_by_value
        card_hash = Hash.new {Array.new}
        @cards.each do |card|
            card_hash[card.value] += [card]
        end
        card_hash.values
    end
end

module Descending_Order
    def descending_order
        cards.sort.reverse!
    end
end

module High_Card_Comparison
    def compare_hands_of_same_rank(other)
        descending_order.each_with_index do |card, i|
            other_card = other.descending_order[i]
            result = card <=> other_card
            return result if (result != 0 || i == descending_order.length - 1)
        end
    end
end

module Num_of_a_Kind_Comparison
    def compare_hands_of_same_rank(other)
        result = kind.first <=> other.kind.first
        if result != 0
            result
        else
            compare_kickers(other)
        end
    end

    def compare_kickers(other)
        kickers.each_with_index do |kicker, i|
            other_kicker = other.kickers[i]
            result = (kicker <=> other_kicker)
            return result if ( result != 0 || i == kickers.length - 1 )
        end
    end

    def kind
        group_by_value.max { |a, b| a.size <=> b.size }.flatten
    end

    def kickers
        group_by_value.select { |group| group.size == 1 }
            .flatten 
            .sort { |a, b| b <=> a }
    end
end