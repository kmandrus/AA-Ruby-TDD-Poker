require_relative 'card.rb'
require_relative 'hand.rb'
require_relative 'display.rb'

class Player
    attr_reader :name, :pot, :money
    attr_accessor :hand
    def initialize(name, hand, money, display)
        @name = name
        @pot = 0
        @hand = hand
        @money = money
        @folded = false
        @display = display
    end

    def new_round
        @folded = false
        @pot = 0
    end

    def receive_cards(cards)
        @hand.add(cards)
    end

    def take_action(current_bet)
        @display.render_new_turn(take_action_instructions(current_bet), self)

        action = nil
        max_raise = money - (current_bet - pot)
        until action do
            action = get_action(max_raise)
        end
        cmd, amount = action
        [cmd, amount]
    end

    def discard_cards
        @display.render_new_turn(discard_cards_instructions, self)

        input = gets.chomp
        begin
            cards = Card.cards_from_string(input)
        rescue => exception
            @display.add_message(exception.message)
            return discard_cards
        end
        begin
            cards.each { |card| @hand.discard(card) } 
        rescue => exception
            @display.add_message(exception.message)
            return discard_cards
        end
        @display.add_message("#{name} discarded #{cards.length} cards.")
        cards.length
    end

    def folded?
        @folded
    end

    def add_to_pot(amount)
        raise "not enough money" unless money >= amount
        @money -= amount
        @pot += amount
    end

    def fold
        @folded = true
        @display.add_message("#{name} folded")
    end
    def raise_bet(amount, current_bet)
        total = (current_bet - pot) + amount
        add_to_pot(total)
        @display.add_message("#{name} raised by #{amount}")
    end
    def see(current_bet)
        current_bet
        amount = current_bet - pot
        add_to_pot(amount)
        @display.add_message("#{name} saw the bet")
    end

    private
    def get_action(max_raise)
        input = gets.chomp
        begin
            cmd, arg = parse_action(input, max_raise)
        rescue => exception
            display.add_message(exception.message)
            display.render
            nil
        else
            [cmd, arg]
        end
    end

    def parse_action(string, max_raise)
        cmd, arg = string.split
        cmd = cmd.to_sym
        case cmd
        when :see
        when :raise
            cmd = :raise_bet
            begin
                arg = arg.to_i
                unless arg > 0 && arg <= max_raise
                    raise "invalid raise amount"
                end
            rescue
                raise "invalid raise amount"
            end 
        when :fold
        else
            raise "invalid action"
        end
        [cmd, arg]
    end

    def take_action_instructions(current_bet)
        amount_to_see = current_bet - pot
        "  You must pay #{amount_to_see} in order to see the current bet.\n\n  Enter 'see,' 'raise,' or 'fold' to perform that action.\n  To raise, follow it with how much you wish to raise\n  the bet by, like this: raise 4\n"
    end
    def discard_cards_instructions
        "  Enter the suit and value of cards to discard.\n  ex: CA is the Ace of Clubs, H3 is the three of hearts\n  You may enter up to three cards, like this: H7 D8 SK\n  Enter nothing to keep all of your cards.\n"
    end
end