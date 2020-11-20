require_relative "card.rb"
require_relative "hand.rb"
require "byebug"

class Display
    attr_accessor :instructions, :hand
    def initialize
        @message_history = []
        @instructions = nil
        @player
        @pot
    end
    def render
        

        system("clear")
        puts "        Poker - 5 Card Draw        "
        
        if @message_history.size > 0
            puts
            puts @message_history
        end
        if @player
            puts
            puts "#{@player.name}  Money Left: #{@player.money}  Pot: #{@pot}  Personal Bet: #{@player.pot}" 
            puts "Hand: #{@player.hand}"
            puts
        end
        if instructions
            puts
            puts @instructions
            puts
        end
    end

    def add_message(string)
        @message_history << string
        @message_history.shift if @message_history.size > 5
        render
    end

    def clear_all
        @message_history = []
        @instructions = nil
        @player = nil
    end

    def render_new_turn(new_instructions, new_player)
        @instructions = new_instructions
        @player = new_player
        render
    end

    def update_pot(new_pot)
        @pot = new_pot
        render
    end

end