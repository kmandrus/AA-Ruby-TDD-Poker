require_relative "card.rb"
require_relative 'hand_types/hand_type_mixins.rb'
filenames = %w(hand_type high_card pair three_of_a_kind four_of_a_kind two_pair straight flush full_house straight_flush)
filenames.each { |file| require_relative "hand_types/" + file + ".rb" }

class Hand
    include Comparable, Descending_Order, Group_by_Value

    def initialize(cards=[])
        @cards = cards
        @hand_type = update_hand_type
    end

    def cards
        @cards.dup
    end

    def add(new_cards)
        @cards += new_cards
        update_hand_type
    end

    def discard(some_cards)
        some_cards.each do |card_to_discard|
            card_found = false
            @cards.each_with_index do |card_in_hand, i|
                if card_in_hand.value == card_to_discard.value &&
                    card_in_hand.suit == card_to_discard.suit
                    
                    card_found = true
                    @cards.delete_at(i)
                    break
                end
            end
            raise "card to discard not in hand" unless card_found
        end
        some_cards.length
    end

    def <=>(other_hand)
        @hand_type <=> other_hand.hand_type
    end

    def name
        @hand_type.name
    end

    def to_s
        @cards.map(&:to_s).join(", ")
    end

    protected
    attr_reader :hand_type
    
    private
    def update_hand_type
        if straight_flush?
            @hand_type = Straight_Flush.new(cards)
        elsif four_of_a_kind?
            @hand_type = Four_of_a_Kind.new(cards)
        elsif full_house?
            @hand_type = Full_House.new(cards)
        elsif flush?
            @hand_type = Flush.new(cards)
        elsif straight?
            @hand_type = Straight.new(cards)
        elsif three_of_a_kind?
            @hand_type = Three_of_a_Kind.new(cards)
        elsif two_pair?
            @hand_type = Two_Pair.new(cards)
        elsif pair?
            @hand_type = Pair.new(cards)
        else
            @hand_type = High_Card.new(cards)
        end
    end

    def straight_flush?
        flush? && straight?
    end
    def flush?
        cards.all? { |card| cards.first.suit == card.suit }
    end
    def straight?
        descending_order.each_with_index do |card, i|
            if i > 0
                prev_val = descending_order[i-1].value_ranking
                if card.value == :A
                    current_val = 1
                else
                    current_val = card.value_ranking
                end
                unless prev_val == current_val + 1
                    return false
                end
            end
        end
        true
    end
    def four_of_a_kind?
        group_by_value.any? { |group| group.length == 4 }
    end
    def three_of_a_kind?
        group_by_value.any? { |group| group.length == 3 }
    end
    def pair?
        group_by_value.count { |group| group.length == 2 } == 1
    end
    def two_pair?
        group_by_value.count { |group| group.length == 2 } == 2
    end
    def full_house?
        group_by_value.count { |group| group.length == 2 } == 1 &&
        group_by_value.any? { |group| group.length == 3 }
    end
end