class Hand
    include Comparable

    def initialize(cards=[])
        @cards = cards
    end

    def cards
        @cards.dup
    end

    def cards_by_value #grouped by value - change to return an array of arrays
        card_hash = Hash.new {Array.new}
        @cards.each do |card|
            card_hash[card.value] += [card]
        end
        card_hash
    end

    def add(new_cards)
        @cards += new_cards
    end

    def discard(some_cards)
        some_cards.each do |card_1| 
            if @cards.none? { |card_2| card_1.value == card_2.value && card_1.suit == card_2.suit }
                raise "card to discard not in hand"
            end
            @cards.delete(card_1)
        end
    end

    def <=>(other_hand)
        if type == other_hand.type
            case type
            when :straight_flush
                compare_straights(other_hand)
            when :four_of_a_kind
                compare_num_of_a_kind(other_hand)
            when :full_house
                compare_full_houses(other_hand)
            when :flush
                compare_high_cards(other_hand)
            when :straight
                compare_straights(other_hand)
            when :three_of_a_kind
                compare_num_of_a_kind(other_hand)
            when :two_pair
                compare_two_pair(other_hand)
            when :pair
                compare_num_of_a_kind(other_hand)
            when :high_card
                compare_high_cards(other_hand)
            else
                raise "hand type not found"
            end
        elsif HAND_RANKINGS[type] > HAND_RANKINGS[other_hand.type]
            return 1
        else
            return -1
        end
    end

    def to_s
        card_strs = []
        @cards.each { |card| card_strs << card.to_s}
        card_strs.join(", ")
    end

    def type
        if straight_flush?
            :straight_flush
        elsif four_of_a_kind?
            :four_of_a_kind
        elsif full_house?
            :full_house
        elsif flush?
            :flush
        elsif straight?
            :straight
        elsif three_of_a_kind?
            :three_of_a_kind
        elsif two_pair?
            :two_pair
        elsif pair?
            :pair
        else
            :high_card
        end
    end

    private
    HAND_RANKINGS = {
        straight_flush: 9,
        four_of_a_kind: 8,
        full_house: 7,
        flush: 6,
        straight: 5,
        three_of_a_kind: 4,
        two_pair: 3,
        pair: 2,
        high_card: 1
    }
    
    protected
    def straight_flush?
        flush? && straight?
    end
    def flush?
        cards.all? { |card| cards.first.suit == card.suit }
    end
    def straight?
        ordered_cards = value_order
        ordered_cards.each_with_index do |card, i|
            if i > 0
                prev_val = ordered_cards[i-1].value_ranking
                if card.value == :A
                    current_value = 1
                else
                    current_value = card.value_ranking
                end
                unless prev_val == current_value + 1
                    return false
                end
            end
        end
        true
    end
    def four_of_a_kind?
        cards.any? do |card|
            cards.count {|count_card| card.value == count_card.value} == 4
        end
    end
    def three_of_a_kind?
        cards.any? do |card|
            cards.count {|count_card| card.value == count_card.value} == 3
        end
    end
    def pair?
        pair_count = 0
        cards_by_value.each_value do |card_group|
            pair_count += 1 if card_group.length == 2
        end
        pair_count == 1
    end 
    def two_pair?
        num_pairs = 0
        cards_by_value.each_value do |card_group|
            num_pairs += 1 if card_group.length == 2
        end
        num_pairs == 2
    end
    def full_house?
        pair? && three_of_a_kind?
    end

    def value_order
        cards.sort.reverse!
    end

    def straight_order
        raise "not a straight" unless straight?
        ordered_cards = value_order
        leading_card, second_card = ordered_cards[0..1]
        if leading_card.value == :A && second_card.value != :K
            ordered_cards << ordered_cards.shift
        end
        ordered_cards
    end

    def compare_num_of_a_kind(their_hand)
        hands = [cards_by_value, their_hand.cards_by_value]
        hands.map! { |hand| hand.values }
        kinds = hands.map do |hand|
            hand.max { |set_1, set_2| set_1.length <=> set_2.length }
        end 
        if kinds.first.first != kinds.last.last
            return kinds.first.first <=> kinds.last.last
        else
            other_cards = hands.map do |hand| 
                hand.reject { |card| card == kinds.first.first }
            end
            return Hand.new(other_cards.first).compare_high_cards(Hand.new(other_cards.last))
        end
    end

    def compare_straights(their_hand)
        my_leading_card = self.straight_order.first
        their_leading_card = their_hand.straight_order.first
        my_leading_card <=> their_leading_card
    end

    def compare_high_cards(their_hand)
        my_cards, their_cards = value_order, their_hand.value_order
        my_cards.length.times do |i|
            my_card, their_card = my_cards[i], their_cards[i]
            if my_card != their_card || i == my_cards.length - 1
                return my_card <=> their_card
            end
        end
    end
    def compare_only_pairs(their_hand)
        unless cards.length == 2 && their_hand.cards.length == 2
            raise "hand must be two cards" 
        end
        cards.first <=> their_hand.cards.first
    end
    def compare_full_houses(their_hand)
        hands = [cards_by_value, their_hand.cards_by_value]
        hands.map! { |hand| hand.values }
        hands = hands.map do |hand|
            hand.sort { |set_1, set_2| set_2.length <=> set_1.length }
        end
        house_1, pair_1 = hands.first
        house_2, pair_2 = hands.last
        if house_1.first != house_2.first
            return house_1.first <=> house_2.first
        else
            return Hand.new(pair_1).compare_only_pairs(Hand.new(pair_2))
        end
    end
    def compare_two_pair(their_hand)
        hands = [cards_by_value, their_hand.cards_by_value]
        pairs = hands.map do |hand|
            hand.values.select { |cards| cards.length == 2 }
        end
        pairs.map! do |set_of_pairs| 
            set_of_pairs.sort do |pair_1, pair_2| 
                pair_2.first <=> pair_1.first
            end
        end
        kickers = hands.map do |hand|
            hand.values.select { |cards| cards.length == 1 }.flatten
        end
        my_high_pair, my_low_pair = pairs.first
        their_high_pair, their_low_pair = pairs.last
        my_kicker, their_kicker = kickers
        if my_high_pair.first != their_high_pair.first
            my_high_pair.first <=> their_high_pair.first
        elsif my_low_pair.first != their_low_pair.first
            my_low_pair.first <=> their_low_pair.first
        else
            my_kicker <=> their_kicker
        end
    end

end

